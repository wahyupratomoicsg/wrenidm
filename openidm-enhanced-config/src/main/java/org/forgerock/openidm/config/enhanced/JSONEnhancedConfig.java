/*
 * The contents of this file are subject to the terms of the Common Development and
 * Distribution License (the License). You may not use this file except in compliance with the
 * License.
 *
 * You can obtain a copy of the License at legal/CDDLv1.0.txt. See the License for the
 * specific language governing permission and limitations under the License.
 *
 * When distributing Covered Software, include this CDDL Header Notice in each file and include
 * the License file at legal/CDDLv1.0.txt. If applicable, add the following below the CDDL
 * Header, with the fields enclosed by brackets [] replaced by your own identifying
 * information: "Portions copyright [year] [name of copyright owner]".
 *
 * Copyright 2011-2016 ForgeRock AS.
 */

package org.forgerock.openidm.config.enhanced;

import static org.forgerock.json.JsonValue.json;
import static org.forgerock.json.JsonValue.object;

import java.util.Dictionary;
import java.util.Map;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.ConfigurationPolicy;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.forgerock.json.JsonValue;
import org.forgerock.json.JsonValueException;
import org.forgerock.openidm.core.PropertyUtil;
import org.forgerock.openidm.core.ServerConstants;
import org.forgerock.openidm.crypto.CryptoService;
import org.forgerock.openidm.util.JsonUtil;
import org.forgerock.util.Reject;
import org.osgi.framework.BundleContext;
import org.osgi.framework.Constants;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * A service to handle enhanced configuration, including nested lists and maps
 * to represent JSON based structures.
 */
@Component(name = JSONEnhancedConfig.PID,
        policy = ConfigurationPolicy.IGNORE,
        description = "OpenIDM Enhanced Config Service",
        immediate = true,
        metatype = true)
@Service
@Properties(
        @Property(name = "suppressMetatypeWarning", value = "true")
)
public class JSONEnhancedConfig implements EnhancedConfig {

    public static final String PID = "org.forgerock.openidm.config.enhanced";

    /**
     * The key in the OSGi configuration dictionary holding the complete JSON
     * configuration string
     */
    public final static String JSON_CONFIG_PROPERTY = "jsonconfig";

    /**
     * Setup logging for the {@link JSONEnhancedConfig}.
     */
    private final static Logger logger = LoggerFactory.getLogger(JSONEnhancedConfig.class);

    /** The {@link CryptoService}. */
    @Reference
    private CryptoService cryptoService;

    public void bindCryptoService(final CryptoService cryptoService) {
        // this is needed to change the scope of the bind method to public instead of protected so that this method
        // can be called in tests.
        this.cryptoService = cryptoService;
    }

    public String getConfigurationFactoryPid(ComponentContext compContext) {
        Object o = compContext.getProperties().get(ServerConstants.CONFIG_FACTORY_PID);
        if (o instanceof String) {
            return (String) o;
        }
        return null;
    }

    @Override
    public JsonValue getConfigurationAsJson(ComponentContext compContext)
            throws InvalidException, InternalErrorException {
        Reject.ifNull(compContext);

        Dictionary<String, Object> dict = compContext.getProperties();
        String servicePid = (String) dict.get(Constants.SERVICE_PID);

        return getConfiguration(dict, compContext.getBundleContext(), servicePid);
    }

    @Override
    public JsonValue getConfiguration(Dictionary<String, Object> dict, BundleContext context,
            String servicePid) throws InvalidException, InternalErrorException {
        return getConfiguration(dict, servicePid, true);
    }

    @Override
    public JsonValue getConfiguration(Dictionary<String, Object> dict, String servicePid,
            boolean decrypt) throws InvalidException, InternalErrorException {
        JsonValue config = getRawConfiguration(dict, servicePid).as(PropertyUtil.propertiesEvaluated);
        if (decrypt) {
            config = cryptoService.decrypt(config);
        }
        return config;
    }

    @Override
    public JsonValue getRawConfiguration(Dictionary<String, Object> dict, String servicePid) throws InvalidException {
        JsonValue jv = json(object());

        if (dict != null) {
            String jsonConfig = (String) dict.get(JSON_CONFIG_PROPERTY);
            logger.trace("Get configuration from JSON config property {}", jsonConfig);

            try {
                if (jsonConfig != null && jsonConfig.trim().length() > 0) {
                    jv = JsonUtil.parseStringified(jsonConfig);
                }
            } catch (Exception ex) {
                throw new InvalidException("Configuration for " + servicePid
                        + " could not be parsed: " + ex.getMessage(), ex);
            }
            logger.trace("Parsed configuration {}", jv);

            try {
                jv.required().expect(Map.class);
            } catch (JsonValueException ex) {
                throw new InvalidException("Component configuration for " + servicePid
                        + " is invalid: " + ex.getMessage(), ex);
            }
        }
        logger.debug("Configuration for {}: {}", servicePid, jv);
        return jv;
    }
}
