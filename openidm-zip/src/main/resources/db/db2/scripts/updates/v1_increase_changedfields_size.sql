ALTER TABLE SOPENIDM.AUDITCONFIG RENAME COLUMN changedfields TO changedfields_old;
ALTER TABLE SOPENIDM.AUDITCONFIG ADD COLUMN changedfields CLOB(2M) NULL;
UPDATE SOPENIDM.AUDITCONFIG SET changedfields = changedfields_old;
ALTER TABLE SOPENIDM.AUDITCONFIG DROP COLUMN changedfields_old;

ALTER TABLE SOPENIDM.AUDITACTIVITY RENAME COLUMN changedfields TO changedfields_old;
ALTER TABLE SOPENIDM.AUDITACTIVITY ADD COLUMN changedfields CLOB(2M) NULL;
UPDATE SOPENIDM.AUDITACTIVITY SET changedfields = changedfields_old;
ALTER TABLE SOPENIDM.AUDITACTIVITY DROP COLUMN changedfields_old;
