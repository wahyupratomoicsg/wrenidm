/**
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright (c) 2014 ForgeRock AS. All Rights Reserved
 *
 * The contents of this file are subject to the terms
 * of the Common Development and Distribution License
 * (the License). You may not use this file except in
 * compliance with the License.
 *
 * You can obtain a copy of the License at
 * http://forgerock.org/license/CDDLv1.0.html
 * See the License for the specific language governing
 * permission and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL
 * Header Notice in each file and include the License file
 * at http://forgerock.org/license/CDDLv1.0.html
 * If applicable, add the following below the CDDL Header,
 * with the fields enclosed by brackets [] replaced by
 * your own identifying information:
 * "Portions Copyrighted [year] [name of copyright owner]"
 */

/*global require, define*/
define([
    "text!templates/admin/AdminBaseTemplate.html",
    "text!templates/admin/ResourcesViewTemplate.html"
], function () {

    /* an unfortunate need to duplicate the file names here, but I haven't
     yet found a way to fool requirejs into doing dynamic dependencies */
    var staticFiles = [
            "templates/admin/AdminBaseTemplate.html",
            "templates/admin/ResourcesViewTemplate.html"
        ],
        deps = arguments;

    return function (server) {
    
        _.each(staticFiles, function (file, i) {
            server.respondWith(
                "GET",
                new RegExp(file.replace(/([\/\.\-])/g, "\\$1") + "$"),
                [
                    200,
                    { },
                    deps[i]
                ]
            );
        });
            
        server.respondWith(
            "GET",   
            "/openidm/info/login",
            [
                200, 
                { },
                "{\"authorizationId\":{\"id\":\"openidm-admin\",\"component\":\"repo/internal/user\",\"roles\":[\"openidm-admin\",\"openidm-authorized\"]},\"parent\":{\"id\":\"f4ffdaa2-6cb1-47cb-a359-e0959086bd61\",\"parent\":null,\"class\":\"org.forgerock.json.resource.RootContext\"},\"class\":\"org.forgerock.json.resource.SecurityContext\",\"authenticationId\":\"openidm-admin\"}"
            ]
        );
    
        server.respondWith(
            "GET",   
            "/openidm/repo/internal/user/openidm-admin",
            [
                200, 
                { },
                "{\"_id\":\"openidm-admin\",\"_rev\":\"2\",\"roles\":\"openidm-admin,openidm-authorized\",\"userName\":\"openidm-admin\",\"password\":{\"$crypto\":{\"type\":\"x-simple-encryption\",\"value\":{\"data\":\"3h8qdTITjZ8yDjW0IR3kRA==\",\"cipher\":\"AES/CBC/PKCS5Padding\",\"iv\":\"s8q+XIxDsAUNIeXTZaITVA==\",\"key\":\"openidm-sym-default\"}}}}"
            ]
        );

        server.respondWith(
            "GET",
            "/openidm/config/repo.orientdb",
            [
                200,
                { },
                "{\"poolMaxSize\":20,\"dbStructure\":{\"orientdbClass\":{\"managed_user\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"},{\"propertyName\":\"userName\",\"indexType\":\"unique\",\"propertyType\":\"string\"},{\"propertyName\":\"givenName\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"sn\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"mail\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"accountStatus\",\"indexType\":\"notunique\",\"propertyType\":\"string\"}]},\"security_keys\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"cluster_states\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"scheduler\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"scheduler_triggers\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"link\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"},{\"propertyName\":\"reconId\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyNames\":[\"linkType\",\"firstId\"],\"indexType\":\"unique\",\"propertyType\":\"string\"},{\"propertyNames\":[\"linkType\",\"secondId\"],\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"managed_apple\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"scheduler_jobs\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"security\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"scheduler_triggerGroups\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"audit_recon\":{\"index\":[{\"propertyName\":\"reconId\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"targetObjectId\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"sourceObjectId\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"timestamp\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"mapping\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"entryType\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"situation\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"status\",\"indexType\":\"notunique\",\"propertyType\":\"string\"}]},\"audit_activity\":{},\"managed_test\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"ui_notification\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"scheduler_calendars\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"config\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"synchronisation_pooledSyncStage\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"},{\"propertyName\":\"sourceId\",\"indexType\":\"unique\",\"propertyType\":\"string\"},{\"propertyName\":\"targetId\",\"indexType\":\"unique\",\"propertyType\":\"string\"},{\"propertyName\":\"reconId\",\"indexType\":\"notunique\",\"propertyType\":\"string\"}]},\"managed_group\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"audit_access\":{\"index\":[{\"propertyName\":\"status\",\"indexType\":\"notunique\",\"propertyType\":\"string\"},{\"propertyName\":\"principal\",\"indexType\":\"notunique\",\"propertyType\":\"string\"}]},\"managed_role\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"scheduler_jobGroups\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]},\"internal_user\":{\"index\":[{\"propertyName\":\"_openidm_id\",\"indexType\":\"unique\",\"propertyType\":\"string\"}]}}},\"dbUrl\":\"plocal:/Users/forgerock/Desktop/openIDM/openidm-zip/target/openidm/db/openidm\",\"embeddedServer\":{\"enabled\":true,\"overrideConfig\":{\"network\":{\"listeners\":{\"binary\":{\"portRange\":\"2424-2424\",\"ipAddress\":\"0.0.0.0\"},\"http\":{\"portRange\":\"2480-2480\",\"ipAddress\":\"127.0.0.1\"}}},\"properties\":[{\"value\":\"false\",\"name\":\"profiler.enabled\"}]},\"studioUi\":{\"enabled\":true},\"defaultProfile\":{\"name\":\"singleinstance\"}},\"poolMinSize\":5,\"queries\":{\"for-userName-count\":\"SELECT count(*) AS total FROM ${unquoted:_resource} WHERE userName = ${uid}\",\"links-for-linkType-count\":\"SELECT count(*) AS total FROM ${unquoted:_resource} WHERE linkType = ${linkType}\",\"scan-tasks\":\"SELECT * FROM ${unquoted:_resource} WHERE ${dotnotation:property} < ${condition.before} AND ${dotnotation:taskState.completed} is NULL SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"get-managed-users-count\":\"SELECT COUNT(*) AS total FROM managed_user\",\"get-by-field-value\":\"select * FROM ${unquoted:_resource} WHERE ${unquoted:field} = ${value} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"query-all-count\":\"select count(*) AS total from ${unquoted:_resource}\",\"query-cluster-instances\":\"SELECT * FROM cluster_states WHERE timestamp <= ${timestamp} AND (state = '1' OR state = '2')\",\"get-managed-users-filtered-count\":\"SELECT COUNT(*) AS total FROM managed_user LET $userNameLike = if((${userName} = ''), '%%', '${unquoted:userName}%'), $mailLike = if((${mail} = ''), '%%', '${unquoted:mail}%'), $snLike = if((${sn} = ''), '%%', '${unquoted:sn}%'), $givenNameLike = if((${givenName} = ''), '%%', '${unquoted:givenName}%') WHERE  userName LIKE $userNameLike AND mail LIKE $mailLike AND sn LIKE $snLike AND givenName LIKE $givenNameLike AND (accountStatus = ${accountStatus} OR ${accountStatus} = '')\",\"get-notifications-for-user-count\":\"select count(*) AS total FROM ${unquoted:_resource} WHERE receiverId = ${userId} order by createDate desc\",\"audit-by-recon-id\":\"select * FROM audit_recon WHERE reconId = ${reconId}\",\"get-by-field-value-count\":\"select count(*) AS total FROM ${unquoted:_resource} WHERE ${unquoted:field} = ${value}\",\"get-users-of-direct-role-count\":\"select count(_openidm_id) AS total FROM ${unquoted:_resource} WHERE roles matches '^(.*,)?${unquoted:role}(,.*)?$' OR ${role} IN roles\",\"query-all-ids-count\":\"select count(_openidm_id) AS total from ${unquoted:_resource}\",\"audit-by-recon-id-type\":\"select * FROM audit_recon WHERE reconId = ${reconId} AND entryType = ${entryType}\",\"for-userName\":\"SELECT * FROM ${unquoted:_resource} WHERE userName = ${uid} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"links-for-firstId\":\"SELECT * FROM ${unquoted:_resource} WHERE linkType = ${linkType} AND firstId = ${firstId} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"links-for-firstId-count\":\"SELECT count(*) AS total FROM ${unquoted:_resource} WHERE linkType = ${linkType} AND firstId = ${firstId}\",\"links-for-secondId-count\":\"SELECT count(*) AS total FROM ${unquoted:_resource} WHERE linkType = ${linkType} AND secondId = ${secondId} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"audit-by-recon-id-situation\":\"select * FROM audit_recon WHERE reconId = ${reconId} AND situation = ${situation}\",\"audit-by-activity-parent-action\":\"select * FROM audit_activity WHERE parentActionId = ${parentActionId}\",\"links-for-linkType\":\"SELECT * FROM ${unquoted:_resource} WHERE linkType = ${linkType} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"query-all\":\"select ${unquoted:fields} from ${unquoted:_resource} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"get-managed-users-filtered\":\"SELECT _openidm_id, userName, mail, givenName, sn, accountStatus FROM managed_user LET $userNameLike = if((${userName} = ''), '%%', '${unquoted:userName}%'), $mailLike = if((${mail} = ''), '%%', '${unquoted:mail}%'), $snLike = if((${sn} = ''), '%%', '${unquoted:sn}%'), $givenNameLike = if((${givenName} = ''), '%%', '${unquoted:givenName}%') WHERE  userName LIKE $userNameLike AND mail LIKE $mailLike AND sn LIKE $snLike AND givenName LIKE $givenNameLike AND (accountStatus = ${accountStatus} OR ${accountStatus} = '') ORDER BY ${unquoted:orderBy} ${unquoted:orderByDir} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"links-for-secondId\":\"SELECT * FROM ${unquoted:_resource} WHERE linkType = ${linkType} AND secondId = ${secondId} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"get-users-of-direct-role\":\"select _openidm_id FROM ${unquoted:_resource} WHERE roles matches '^(.*,)?${unquoted:role}(,.*)?$' OR ${role} IN roles SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"scan-tasks-count\":\"SELECT count(*) AS total FROM ${unquoted:_resource} WHERE ${dotnotation:property} < ${condition.before} AND ${dotnotation:taskState.completed} is NULL\",\"audit-by-mapping\":\"select * FROM audit_recon WHERE mapping = ${mappingName}\",\"query-all-ids\":\"select _openidm_id from ${unquoted:_resource} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"get-managed-users\":\"SELECT _openidm_id, userName, mail, givenName, sn, accountStatus FROM managed_user ORDER BY ${unquoted:orderBy} ${unquoted:orderByDir} SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"audit-last-recon-for-all-mappings\":\"SELECT max(messageDetail.started) AS last_started,  max(messageDetail.ended) AS last_ended, mapping from audit_recon where entryType='summary' group by mapping\",\"credential-query\":\"SELECT * FROM ${unquoted:_resource} WHERE userName = ${username} AND coalesce(accountStatus, 'active') <> 'inactive'\",\"get-notifications-for-user\":\"select * FROM ${unquoted:_resource} WHERE receiverId = ${userId} order by createDate desc SKIP ${unquoted:_pagedResultsOffset} LIMIT ${unquoted:_pageSize}\",\"credential-internaluser-query\":\"SELECT * FROM internal_user WHERE _openidm_id = ${username}\"},\"user\":\"admin\"}"
            ]
        );

        server.respondWith(
            "POST",
            "/openidm/system?_action=test",
            [
                200,
                { },
                "[{\"name\":\"ldap\",\"ok\":true,\"connectorRef\":{\"connectorName\":\"org.identityconnectors.ldap.LdapConnector\",\"bundleName\":\"org.forgerock.openicf.connectors.ldap-connector\",\"bundleVersion\":\"[1.1.0.1,1.1.2.0)\"},\"config\":\"config/provisioner.openicf/ldap\"}]"
            ]
        );

        server.respondWith(
            "GET",
            "/openidm/config",
            [
                200,
                { },
                "{\"configurations\":[{\"_id\":\"router\",\"pid\":\"router\",\"factoryPid\":null},{\"_id\":\"info/login\",\"pid\":\"info.e24ab2a7-764d-40d3-ae7f-2c97cccee6ce\",\"factoryPid\":\"info\"},{\"_id\":\"ui.context/admin\",\"pid\":\"ui.context.818fd477-c66a-437a-b63b-d241982ba945\",\"factoryPid\":\"ui.context\"},{\"_id\":\"authentication\",\"pid\":\"authentication\",\"factoryPid\":null},{\"_id\":\"servletfilter/cors\",\"pid\":\"servletfilter.9d29bf26-d048-47d5-a2e8-04ce5f297399\",\"factoryPid\":\"servletfilter\"},{\"_id\":\"policy\",\"pid\":\"policy\",\"factoryPid\":null},{\"_id\":\"org.apache.felix.fileinstall/activiti\",\"pid\":\"org.apache.felix.fileinstall.e05cb98e-216c-4021-9a91-0ec03e8a31ce\",\"factoryPid\":\"org.apache.felix.fileinstall\"},{\"_id\":\"endpoint/gettasksview\",\"pid\":\"endpoint.649abca6-5c3e-47c8-83af-e4c32c9d3c62\",\"factoryPid\":\"endpoint\"},{\"_id\":\"script\",\"pid\":\"script\",\"factoryPid\":null},{\"_id\":\"managed\",\"pid\":\"managed\",\"factoryPid\":null},{\"_id\":\"ui/themeconfig\",\"pid\":\"ui.0dd204dd-4f01-445f-ac9a-d788f7affc5d\",\"factoryPid\":\"ui\"},{\"_id\":\"endpoint/getprocessesforuser\",\"pid\":\"endpoint.ff987406-fde4-4d38-8eaa-1b68c71406c1\",\"factoryPid\":\"endpoint\"},{\"_id\":\"info/ping\",\"pid\":\"info.3f68bcde-2096-41d3-9a92-4fbef11827fa\",\"factoryPid\":\"info\"},{\"_id\":\"endpoint/usernotifications\",\"pid\":\"endpoint.6d3734da-9885-4021-a846-57402afef675\",\"factoryPid\":\"endpoint\"},{\"_id\":\"servletfilter/gzip\",\"pid\":\"servletfilter.ff9d44ec-21e2-445e-8bee-79e684156acf\",\"factoryPid\":\"servletfilter\"},{\"_id\":\"endpoint/jqgrid\",\"pid\":\"endpoint.e6afd363-6cb0-44e6-aede-1c69f72ec6a1\",\"factoryPid\":\"endpoint\"},{\"_id\":\"process/access\",\"pid\":\"process.c29b1145-91a0-46f3-a2ae-99bffa071670\",\"factoryPid\":\"process\"},{\"_id\":\"endpoint/siteIdentification\",\"pid\":\"endpoint.e47da4a9-a5a8-44b2-85cc-b4f684e5b902\",\"factoryPid\":\"endpoint\"},{\"_id\":\"audit\",\"pid\":\"audit\",\"factoryPid\":null},{\"_id\":\"ui/configuration\",\"pid\":\"ui.63d34d3c-709e-4d15-b71b-4690c2ed0785\",\"factoryPid\":\"ui\"},{\"_id\":\"repo.orientdb\",\"pid\":\"repo.orientdb\",\"factoryPid\":null},{\"_id\":\"scheduler\",\"pid\":\"scheduler\",\"factoryPid\":null},{\"_id\":\"schedule/recon\",\"pid\":\"schedule.37f7ec00-0c4b-43e6-b61b-c5d9c41e2d2f\",\"factoryPid\":\"schedule\"},{\"_id\":\"endpoint/securityQA\",\"pid\":\"endpoint.c5ed6ba3-02e0-4fc9-84ea-fac698cbd859\",\"factoryPid\":\"endpoint\"},{\"_id\":\"ui.context/enduser\",\"pid\":\"ui.context.25a8a874-81b7-4286-b88b-2f654e291b9e\",\"factoryPid\":\"ui.context\"},{\"_id\":\"cluster\",\"pid\":\"cluster\",\"factoryPid\":null},{\"_id\":\"endpoint/linkedView\",\"pid\":\"endpoint.a6a8db8d-0046-46f6-b097-72fef82c6c0f\",\"factoryPid\":\"endpoint\"},{\"_id\":\"provisioner.openicf/ldap\",\"pid\":\"provisioner.openicf.432b43b0-c34f-47ef-bc00-02b7c4f8f277\",\"factoryPid\":\"provisioner.openicf\"},{\"_id\":\"endpoint/getavailableuserstoassign\",\"pid\":\"endpoint.f9dd95bc-9ba8-4ecd-bb78-f2542776cb4d\",\"factoryPid\":\"endpoint\"},{\"_id\":\"ui/countries\",\"pid\":\"ui.ab136621-733d-4838-ba1b-50e8e8f16ad6\",\"factoryPid\":\"ui\"},{\"_id\":\"sync\",\"pid\":\"sync\",\"factoryPid\":null},{\"_id\":\"org.apache.felix.fileinstall/openidm\",\"pid\":\"org.apache.felix.fileinstall.98a5bf36-51c2-4797-bb3a-390d4e7c5199\",\"factoryPid\":\"org.apache.felix.fileinstall\"},{\"_id\":\"org.apache.felix.fileinstall/ui\",\"pid\":\"org.apache.felix.fileinstall.404910f7-806f-4efd-b872-d26b5f12b2d6\",\"factoryPid\":\"org.apache.felix.fileinstall\"},{\"_id\":\"workflow\",\"pid\":\"workflow\",\"factoryPid\":null},{\"_id\":\"ui/secquestions\",\"pid\":\"ui.b79d085c-f340-47d2-87ee-e236dd7da730\",\"factoryPid\":\"ui\"}]}"
            ]
        );

        server.respondWith(
            "GET",
            "/openidm/config/managed",
            [
                200,
                { },
                "{\"objects\":[{\"postUpdate\":{\"type\":\"text/javascript\",\"file\":\"roles/update-users-of-role.js\"},\"postCreate\":{\"type\":\"text/javascript\",\"file\":\"roles/update-users-of-role.js\"},\"postDelete\":{\"type\":\"text/javascript\",\"file\":\"roles/update-users-of-role.js\"},\"name\":\"role\"},{\"name\":\"apple\"},{\"onDelete\":{\"type\":\"text/javascript\",\"file\":\"ui/onDelete-user-cleanup.js\"},\"onCreate\":{\"type\":\"text/javascript\",\"file\":\"ui/onCreate-user-set-default-fields.js\"},\"properties\":[{\"encryption\":{\"key\":\"openidm-sym-default\"},\"name\":\"securityAnswer\",\"scope\":\"private\"},{\"encryption\":{\"key\":\"openidm-sym-default\"},\"name\":\"password\",\"scope\":\"private\"},{\"type\":\"virtual\",\"name\":\"effectiveRoles\"},{\"type\":\"virtual\",\"name\":\"effectiveAssignments\"},{\"type\":\"virtual\",\"name\":\"test\",\"scope\":\"private\"}],\"name\":\"user\"},{\"properties\":[{\"name\":\"test\"}],\"name\":\"test\"}]}"
            ]
        );
    };

});
