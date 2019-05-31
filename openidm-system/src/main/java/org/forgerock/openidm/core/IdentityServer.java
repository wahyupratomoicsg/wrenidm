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
 * Portions Copyright 2018 Wren Security.
 */

package org.forgerock.openidm.core;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * This class defines the core of the Identity Server.
 *
 * @version $Revision$ $Date$
 */
public final class IdentityServer implements PropertyAccessor {
    /**
     * The singleton Identity Server instance.
     */
    private static volatile IdentityServer IDENTITY_SERVER;

    /**
     * The various defined boot properties.
     */
    public static final String KEYSTORE_TYPE = "openidm.keystore.type";
    public static final String KEYSTORE_PROVIDER = "openidm.keystore.provider";
    public static final String KEYSTORE_LOCATION = "openidm.keystore.location";
    public static final String KEYSTORE_KEY_PASSWORD = "openidm.keystore.key.password";
    public static final String KEYSTORE_PASSWORD = "openidm.keystore.password";

    public static final String TRUSTSTORE_LOCATION = "openidm.truststore.location";
    public static final String TRUSTSTORE_TYPE = "openidm.truststore.type";
    public static final String TRUSTSTORE_PASSWORD = "openidm.truststore.password";
    public static final String TRUSTSTORE_PROVIDER = "openidm.truststore.provider";

    public static final String CONFIG_CRYPTO_ALIAS = "openidm.config.crypto.alias";
    public static final String CONFIG_CRYPTO_ALIAS_SELF_SERVICE = "openidm.config.crypto.selfservice.sharedkey.alias";
    public static final String PKCS11_CONFIG = "openidm.security.pkcs11.config";
    public static final String SSL_HOST_ALIASES = "openidm.ssl.host.aliases";
    public static final String HTTPS_KEYSTORE_CERT_ALIAS = "openidm.https.keystore.cert.alias";
    public static final String NODE_ID = "openidm.node.id";

    /**
     * Precedence is
     * 1. System Properties
     * 2. Boot file properties,
     * 3. Explicit config properties
     */
    private final SystemPropertyAccessor systemPropertyAccessor = new SystemPropertyAccessor(null);
    private final Map<String, String> bootFileProperties;
    private final PropertyAccessor configProperties;
    private File bootPropertyFile = null;

    /**
     * Creates a new identity environment configuration initialized with a copy
     * of the provided set of properties.
     *
     * @param properties
     *   The properties to use when initializing this environment configuration, or {@code null} to
     *   use an empty set of properties.
     */
    /* default */ IdentityServer(PropertyAccessor properties) {
        configProperties = properties;

        String bootFileName
            = getProperty(
                ServerConstants.PROPERTY_BOOT_FILE_LOCATION,
                ServerConstants.DEFAULT_BOOT_FILE_LOCATION);

        bootFileProperties = loadProps(bootFileName);
    }

    /**
     * Get the current {@code IdentityServer} singleton instance.
     *
     * <p>The server must have been initialized before this method can be called. Calling it before
     * the server is initialized yields an {@link IllegalStateException}.
     *
     * @see #initInstance(IdentityServer)
     * @see #initInstance(PropertyAccessor)
     *
     * @return
     *   The current, singleton {@code IdentityServer} instance.
     *
     * @throws IllegalStateException
     *   If the server has not yet been initialized.
     */
    public static IdentityServer getInstance() {
        if (!isInitialized()) {
            throw new IllegalStateException("IdentityServer has not been initialised");
        }

        return IDENTITY_SERVER;
    }

    /**
     * Get whether or not the {@code IdentityServer} has been initialized.
     *
     * @return
     *   {@code true} if the server has been initialized; or, {@code false} if it has not been
     *   initialized.
     */
    public static boolean isInitialized() {
        return (IDENTITY_SERVER != null);
    }

    /**
     * Initialize the singleton {@code IdentityServer} instance with the
     * provided {@link PropertyAccessor} instance.
     * <p>
     * This and the {@link #initInstance(IdentityServer)} method can be called
     * only once. Subsequent calls will result in a {@link IllegalStateException}.
     *
     * @param properties
     *   The parent {@code PropertyAccessor}.
     *
     * @return
     *   New instance of {@link IdentityServer}.
     *
     * @throws IllegalStateException
     *   If this method is called more then once.
     */
    public static synchronized IdentityServer initInstance(PropertyAccessor properties) {
        if (!isInitialized()) {
            final IdentityServer newInstance;

            if (properties instanceof IdentityServer) {
                newInstance = (IdentityServer)properties;
            } else {
                newInstance = new IdentityServer(properties);
            }

            IDENTITY_SERVER = newInstance;

            return newInstance;
        } else {
            throw new IllegalStateException("IdentityServer has been initialised already");
        }
    }

    /**
     * Initialize the singleton {@code IdentityServer} instance with the
     * provided {@link IdentityServer} instance, or the default instance.
     *
     * <p>This and the {@link #initInstance(PropertyAccessor)} method can be called only once.
     * Subsequent calls will result in a {@link IllegalStateException}.
     *
     * @param server
     *   New instance of {@link IdentityServer}. Can be {@code null} to generate a default instance
     *   that uses only system properties.
     *
     * @return
     *   Same instance as the {@code server} parameter, if not {@code null}; otherwise, the new
     *   {@link IdentityServer instance}.
     *
     * @throws IllegalStateException
     *   If this method is called more then once.
     */
    public static synchronized IdentityServer initInstance(final IdentityServer server) {
        if (!isInitialized()) {
            final IdentityServer newInstance;

            if (server != null) {
                newInstance = server;
            } else {
                newInstance = new IdentityServer(null);
            }

            IDENTITY_SERVER = newInstance;

            return newInstance;
        } else {
            throw new IllegalStateException("IdentityServer has been initialised already");
        }
    }

    /**
     * Clear the singleton {@code IdentityServer} instance so that the identity server can be
     * initialized again.
     *
     * <p>This method is intended only for use internally by the identity server and tests. There
     * is typically no good reason to call this method in a production environment.
     */
    /* default */ static synchronized void clearInstance() {
        IDENTITY_SERVER = null;
    }

    /**
     * Retrieves the property value by looking in System properties, boot properties, and then
     * config properties.
     *
     * @param key The name of the requested property.
     * @param defaultValue the value returned if not found in the propertyAccessors.
     * @param expected the expected class of the returned value.
     * @param <T> Type bound to the returned value.
     * @return The value of the stored property if found, else the defaultValue.
     */
    @SuppressWarnings("unchecked")
    public <T> T getProperty(String key, T defaultValue, Class<T> expected) {
        // First check System properties for our value.
        T value = systemPropertyAccessor.getProperty(key, null, expected);

        if (null == value) {
            // Not found in system properties, now check the boot file, if the property is expected
            // to be a String.
            boolean expectsString = ((null != expected && expected.isAssignableFrom(String.class))
                    || defaultValue instanceof String);

            if (null != bootFileProperties
                && null != key
                && expectsString) {
                value = (T) bootFileProperties.get(key);
            }
        }
        if (null == value) {
            // Not found in System or Boot, now check the configProperties, if it was set.
            if (null != configProperties) {
                value = configProperties.getProperty(key, defaultValue, expected);
            }
        }
        // If still not found at this point, return the default.
        return (null != value)
                ? value
                : defaultValue;

    }

    /**
     * Retrieves the property with the specified name (case insensitvie). The
     * check will first be made in the boot properties file, the local config
     * properties, but if no value is found then the JVM system properties will
     * be checked.
     *
     * @param name
     *            The name of the property to retrieve.
     * @param defaultValue
     *            the default value to return if the property is not set
     * @param withPropertySubstitution
     *            whether to use boot and system property substitution
     * @return The property with the specified name, or {@code defaultValue} if
     *         no such property is defined.
     */
    public String getProperty(String name, String defaultValue, boolean withPropertySubstitution) {
        String result = getProperty(name, defaultValue, String.class);

        if (withPropertySubstitution) {
            result = (String) PropertyUtil.substVars(result, getInstance(), false);
        }

        return result;
    }

    /**
     * Retrieves the property with the specified name (case insensitvie). The
     * check will first be made in the boot properties file, the local config
     * properties, but if no value is found then the JVM system properties will
     * be checked.
     *
     * @param name
     *            The name of the property to retrieve.
     * @param defaultValue
     *            the default value to return if the property is not set
     * @return The property with the specified name, or {@code defaultValue} if
     *         no such property is defined.
     */
    public String getProperty(String name, String defaultValue) {
        return getProperty(name, defaultValue, String.class);
    }

    /**
     * Retrieves the property with the specified name (case insensitvie). The
     * check will first be made in the local config properties, the boot
     * properties file, but if no value is found then the JVM system properties
     * will be checked.
     *
     * @param name
     *            The name of the property to retrieve.
     * @return The property with the specified name, or {@code null} if no such
     *         property is defined.
     */
    public String getProperty(String name) {
        return getProperty(name, null, String.class);
    }

    // Case insensitive retrieval of system properties
    private String getSystemPropertyIgnoreCase(String name) {
        Properties allProps = System.getProperties();
        for (Object key : allProps.keySet()) {
            if (((String) key).equalsIgnoreCase(name)) {
                return (String) allProps.get(key);
            }
        }
        return null;
    }

    /**
     * Retrieves the path to the root directory for this instance of the
     * Identity Server.
     *
     * @return The path to the root directory for this instance of the Identity
     *         Server.
     */
    public String getServerRoot() {
        String root = getProperty(ServerConstants.LAUNCHER_PROJECT_LOCATION, null, String.class);
        // Keep the backward compatibility
        if (null == root) {
            root = getProperty(ServerConstants.PROPERTY_SERVER_ROOT, null, String.class);
        }

        if (null != root) {
            File r = new File(root);
            if (r.isAbsolute()) {
                return root;
            } else {
                return r.getAbsolutePath();
            }
        }
        // We don't know where the server root is, so we'll have to assume it's
        // the current working directory.
        root = System.getProperty("user.dir");
        return root;
    }

    /**
     * Retrieves the path to the root directory for this instance of the
     * Identity Server.
     *
     * @return The path to the root directory for this instance of the Identity
     *         Server.
     */
    public URI getServerRootURI() {
        return URI.create(getServerRoot());
    }

    public String getClusterName() {
        return getProperty("openidm.system.site.name", "default");
    }

    public String getNodeName() {
        try {
            return getProperty("openidm.system.node.name", InetAddress.getLocalHost().getHostName());
        } catch (UnknownHostException e) {
            return getProperty("openidm.system.node.name", "default");
        }
    }

    /**
     * Retrieves a <CODE>File</CODE> object corresponding to the specified path.
     * If the given path is an absolute path, then it will be used. If the path
     * is relative, then it will be interpreted as if it were relative to the
     * Identity Server root.
     *
     * @param path
     *            The path string to be retrieved as a <CODE>File</CODE>
     * @return A <CODE>File</CODE> object that corresponds to the specified
     *         path.
     */
    public static File getFileForPath(String path) {
        return getFileForPath(path, getInstance().getServerRoot());
    }

    /**
     * Retrieves a {@code File} object corresponding to the <b>Install</b> path.
     * If the given path is an absolute path, then it will be used. If the path
     * is relative, then it will be interpreted as if it were relative to the
     * Install location.
     *
     * @param path
     *            The path string to be retrieved as a {@code File}
     * @return A {@code File} object that corresponds to the specified path.
     */
    public static File getFileForInstallPath(String path) {
        return getFileForPath(path, getInstance().getInstallLocation());
    }

    /**
     * Retrieves a {@code File} object corresponding to the <b>Project</b> path.
     * If the given path is an absolute path, then it will be used. If the path
     * is relative, then it will be interpreted as if it were relative to the
     * Project location.
     *
     * @param path
     *            The path string to be retrieved as a {@code File}
     * @return A {@code File} object that corresponds to the specified path.
     */
    public static File getFileForProjectPath(String path) {
        return getFileForPath(path, getInstance().getProjectLocation());
    }

    /**
     * Retrieves a {@code File} object corresponding to the <b>Working</b> path.
     * If the given path is an absolute path, then it will be used. If the path
     * is relative, then it will be interpreted as if it were relative to the
     * Working location.
     *
     * @param path
     *            The path string to be retrieved as a {@code File}
     * @return A {@code File} object that corresponds to the specified path.
     */
    public static File getFileForWorkingPath(String path) {
        return getFileForPath(path, getInstance().getWorkingLocation());
    }

    /**
     * Retrieves a <CODE>File</CODE> object corresponding to the specified path.
     * If the given path is an absolute path, then it will be used. If the path
     * is relative, then it will be interpreted as if it were relative to the
     * Identity Server root.
     *
     * @param path
     *            The path string to be retrieved as a <CODE>File</CODE>
     * @param serverRoot
     *            the server root to resolve against
     * @return A <CODE>File</CODE> object that corresponds to the specified
     *         path.
     */
    public static File getFileForPath(String path, String serverRoot) {
        if (null == path) {
            return null;
        }
        File f = new File(path);

        if (f.isAbsolute()) {
            // logger.trace("getFileForPath is absolute: {}", path);
            return f;
        } else {
            // logger.trace("getFileForPath is relative: {} resolving against {}",
            // path, serverRoot);
            return new File(serverRoot, path).getAbsoluteFile();
        }
    }

    /**
     * Retrieves a <CODE>File</CODE> object corresponding to the specified path.
     * If the given path is an absolute path, then it will be used. If the path
     * is relative, then it will be interpreted as if it were relative to the
     * {@code rootLocation} parameter.
     *
     * @param path
     *            The path string to be retrieved as a {@code File}
     * @param rootLocation
     *            the server root to resolve against
     * @return A {@code File} object that corresponds to the specified path.
     */
    public static File getFileForPath(String path, File rootLocation) {
        File f = new File(path);

        if (f.isAbsolute()) {
            // logger.trace("getFileForPath is absolute: {}", path);
            return f;
        } else {
            // logger.trace("getFileForPath is relative: {} resolving against {}",
            // path, serverRoot);
            return new File(rootLocation, path).getAbsoluteFile();
        }
    }

    /**
     * Get the file (if any) from which boot properties were loaded.
     *
     * @return
     *   The boot properties file.
     */
    public File getBootPropertyFile() {
        return bootPropertyFile;
    }

    public File getInstallLocation() {
        return getLocation(ServerConstants.LAUNCHER_INSTALL_LOCATION);
    }

    public File getProjectLocation() {
        return getLocation(ServerConstants.LAUNCHER_PROJECT_LOCATION);
    }

    public File getWorkingLocation() {
        return getLocation(ServerConstants.LAUNCHER_WORKING_LOCATION);
    }

    protected File getLocation(String propertyName) {
        String location = getProperty(propertyName, null, String.class);
        if (null == location) {
            location = getProperty(ServerConstants.PROPERTY_SERVER_ROOT, null, String.class);
        }
        return new File(null != location ? location : "").getAbsoluteFile();
    }

    public URL getInstallLocationURL() {
        URL location = getLocationURL(ServerConstants.LAUNCHER_INSTALL_URL);
        if (null == location) {
            try {
                location =
                        getLocation(ServerConstants.LAUNCHER_INSTALL_LOCATION).getAbsoluteFile()
                                .toURI().toURL();
            } catch (MalformedURLException e) {
                /* ignore because the file is absolute */
            }
        }
        return location;
    }

    public URL getProjectLocationURL() {
        URL location = getLocationURL(ServerConstants.LAUNCHER_PROJECT_URL);
        if (null == location) {
            try {
                location =
                        getLocation(ServerConstants.LAUNCHER_PROJECT_LOCATION).getAbsoluteFile()
                                .toURI().toURL();
            } catch (MalformedURLException e) {
                /* ignore because the file is absolute */
            }
        }
        return location;
    }

    public URL getWorkingLocationURL() {
        URL location = getLocationURL(ServerConstants.LAUNCHER_WORKING_URL);
        if (null == location) {
            try {
                location =
                        getLocation(ServerConstants.LAUNCHER_WORKING_LOCATION).getAbsoluteFile()
                                .toURI().toURL();
            } catch (MalformedURLException e) {
                /* ignore because the file is absolute */
            }
        }
        return location;
    }

    protected URL getLocationURL(String propertyName) {
        String location = getProperty(ServerConstants.LAUNCHER_PROJECT_URL, null, String.class);
        if (null != location) {
            try {
                return new URL(location);
            } catch (MalformedURLException e) {
                throw new IllegalArgumentException("The " + propertyName + " has no valid value!",
                        e);
            }
        }
        return null;
    }

    /**
     * Loads boot properties file
     *
     * @return properties in boot properties file, keys in lower case
     */
    private Map<String, String> loadProps(String bootFileLocation) {
        File bootFile = IdentityServer.getFileForPath(bootFileLocation, getServerRoot());
        Map<String, String> entries = new HashMap<>();

        if (null == bootFile) {
            System.out.println("No boot file properties: "
                    + ServerConstants.PROPERTY_BOOT_FILE_LOCATION);
        } else if (!bootFile.exists()) {
            // TODO: move this class out of system bundle so we can use logging
            // logger.info("No boot properties file detected at {}.",
            // bootFile.getAbsolutePath());
            System.out.println("No boot properties file detected at " + bootFile.getAbsolutePath());
        } else {
            System.out.println("Using boot properties at " + bootFile.getAbsolutePath());
            bootPropertyFile = bootFile;
            InputStream in = null;
            try {
                Properties prop = new Properties();
                in = new BufferedInputStream(new FileInputStream(bootFile));
                prop.load(in);
                for (Map.Entry<Object, Object> entry : prop.entrySet()) {
                    entries.put((String) entry.getKey(), (String) entry.getValue());
                }
            } catch (FileNotFoundException ex) {
                // logger.info("Boot properties file {} not found",
                // bootFile.getAbsolutePath(), ex);
            } catch (IOException ex) {
                // logger.warn("Failed to load boot properties file {}",
                // bootFile.getAbsolutePath(), ex);
                throw new RuntimeException("Failed to load boot properties file "
                        + bootFile.getAbsolutePath() + " " + ex.getMessage(), ex);
            } finally {
                if (in != null) {
                    try {
                        in.close();
                    } catch (IOException ex) {
                        // logger.warn("Failure in closing boot properties file",
                        // ex);
                    }
                }
            }
        }

        return entries;
    }
}
