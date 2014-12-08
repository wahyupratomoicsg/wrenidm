DROP DATABASE DOPENIDM;
DROP STOGROUP GOPENIDM;
COMMIT;
CREATE STOGROUP GOPENIDM
       VOLUMES ('*')
       VCAT     VSDB2T
;
CREATE DATABASE   DOPENIDM
       STOGROUP   GOPENIDM
       BUFFERPOOL BP2
;



CREATE SCHEMA SOPENIDM;



CREATE TABLESPACE SOIDM00
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE TABLE SOPENIDM.OBJECTTYPES
       (ID                         INTEGER
                                   GENERATED BY DEFAULT
                                   AS IDENTITY
                                   ( CYCLE )
       ,OBJECTTYPE                 VARCHAR(255)   NOT NULL
       ,PRIMARY KEY (ID)
       )
       IN DOPENIDM.SOIDM00
;
COMMENT ON TABLE SOPENIDM.OBJECTTYPES IS
'OPENIDM - Dictionary table for object types';

CREATE UNIQUE INDEX SOPENIDM.PK_OBJECTTYPES
       ON SOPENIDM.OBJECTTYPES
       (ID                         ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE UNIQUE INDEX SOPENIDM.IDX_OBJECTTYPES_OBJECTTYPE
       ON SOPENIDM.OBJECTTYPES
       (OBJECTTYPE                 ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM01
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE LOB TABLESPACE SOIDM01A
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   LOB
       CLOSE      NO
;
CREATE TABLE SOPENIDM.GENERICOBJECTS
       (ID                         INTEGER
                                   GENERATED BY DEFAULT
                                   AS IDENTITY
                                   ( CYCLE )
       ,OBJECTTYPES_ID             INTEGER        NOT NULL
       ,OBJECTID                   VARCHAR(255)   NOT NULL
       ,REV                        VARCHAR(38)    NOT NULL
       ,FULLOBJECT                 CLOB(2M)
       ,PRIMARY KEY (ID)
       ,CONSTRAINT FK_GENERICOBJECTS_OBJECTTYPES
          FOREIGN KEY
         (OBJECTTYPES_ID )
          REFERENCES SOPENIDM.OBJECTTYPES (ID )
         ON DELETE CASCADE
       )
       IN DOPENIDM.SOIDM01
;
COMMENT ON TABLE SOPENIDM.GENERICOBJECTS IS
'OPENIDM - Generic table For Any Kind Of Objects';

CREATE AUXILIARY TABLE SOPENIDM.GENERICOBJECTS_AUX
       IN DOPENIDM.SOIDM01A
       STORES SOPENIDM.GENERICOBJECTS
       COLUMN FULLOBJECT
;
COMMENT ON TABLE SOPENIDM.GENERICOBJECTS_AUX IS
'OPENIDM - Auxiliary table for GENERICOBJECTS.FULLOBJECT';

CREATE UNIQUE INDEX SOPENIDM.PK_GENERICOBJECTS
       ON SOPENIDM.GENERICOBJECTS
       (ID                           ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE INDEX SOPENIDM.FK_GENERICOBJECTS_OBJECTTYPES
       ON SOPENIDM.GENERICOBJECTS
       (OBJECTTYPES_ID               ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE UNIQUE INDEX SOPENIDM.GENERICOBJECTS_AUX
       ON SOPENIDM.GENERICOBJECTS_AUX
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE INDEX SOPENIDM.IDX_GENERICOBJECTS_OBJECTID
       ON SOPENIDM.GENERICOBJECTS
       (OBJECTID                     ASC
       ,OBJECTTYPES_ID               ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM02
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE TABLE SOPENIDM.GENERICOBJECTPROPERTIES
       (GENERICOBJECTS_ID          INTEGER        NOT NULL
       ,PROPKEY                    VARCHAR(255)   NOT NULL
       ,PROPTYPE                   VARCHAR(32)
       ,PROPVALUE                  VARCHAR(255)
       ,CONSTRAINT FK_GENERICOBJECTPROPERTIES_GENERICOBJECTS
          FOREIGN KEY
         (GENERICOBJECTS_ID )
          REFERENCES SOPENIDM.GENERICOBJECTS (ID )
         ON DELETE CASCADE
       )
       IN DOPENIDM.SOIDM02
;
COMMENT ON TABLE SOPENIDM.GENERICOBJECTPROPERTIES IS
'OPENIDM - Properties of Generic Objects';

CREATE UNIQUE INDEX SOPENIDM.IDX_GENERICOBJECTPROPERTIES_PROP
       ON SOPENIDM.GENERICOBJECTPROPERTIES
       (PROPKEY                      ASC
       ,PROPVALUE                    ASC
       ,GENERICOBJECTS_ID            ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE INDEX SOPENIDM.IDX_GENERICOBJECTPROPERTIES_GENERICOBJECTS
       ON SOPENIDM.GENERICOBJECTPROPERTIES
       (GENERICOBJECTS_ID            ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM03
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE LOB TABLESPACE SOIDM03A
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   LOB
       CLOSE      NO
;
CREATE TABLE SOPENIDM.MANAGEDOBJECTS
       (ID                         INTEGER
                                   GENERATED BY DEFAULT
                                   AS IDENTITY
                                   ( CYCLE )
       ,OBJECTTYPES_ID             INTEGER        NOT NULL
       ,OBJECTID                   VARCHAR(255)   NOT NULL
       ,REV                        VARCHAR(38)    NOT NULL
       ,FULLOBJECT                 CLOB(2M)
       ,PRIMARY KEY (ID)
       ,CONSTRAINT FK_MANAGEDOBJECTS_OBJECTTYPES
          FOREIGN KEY
         (OBJECTTYPES_ID )
          REFERENCES SOPENIDM.OBJECTTYPES (ID )
         ON DELETE CASCADE
       )
       IN DOPENIDM.SOIDM03
;
COMMENT ON TABLE SOPENIDM.MANAGEDOBJECTS IS
'OPENIDM - Generic Table For Managed Objects';

CREATE AUXILIARY TABLE SOPENIDM.MANAGEDOBJECTS_AUX
       IN DOPENIDM.SOIDM03A
       STORES SOPENIDM.MANAGEDOBJECTS
       COLUMN FULLOBJECT
;
COMMENT ON TABLE SOPENIDM.MANAGEDOBJECTS_AUX IS
'OPENIDM - Auxiliary table for MANAGEDOBJECTS_AUX.FULLOBJECT';

CREATE UNIQUE INDEX SOPENIDM.PK_MANAGEDOBJECTS
       ON SOPENIDM.MANAGEDOBJECTS
       (ID                           ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE INDEX SOPENIDM.FK_MANAGEDOBJECTS_OBJECTTYPES
       ON SOPENIDM.MANAGEDOBJECTS
       (OBJECTTYPES_ID               ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE UNIQUE INDEX SOPENIDM.MANAGEDOBJECTS_AUX
       ON SOPENIDM.MANAGEDOBJECTS_AUX
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM04
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP32K
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE TABLE SOPENIDM.MANAGEDOBJECTPROPERTIES
       (MANAGEDOBJECTS_ID          INTEGER        NOT NULL
       ,PROPKEY                    VARCHAR(255)   NOT NULL
       ,PROPTYPE                   VARCHAR(32)
       ,PROPVALUE                  VARCHAR(32000)
       ,CONSTRAINT FK_MANAGEDOBJECTPROPERTIES_MANAGEDOBJECTS
          FOREIGN KEY
         (MANAGEDOBJECTS_ID )
          REFERENCES SOPENIDM.MANAGEDOBJECTS (ID )
         ON DELETE CASCADE
       )
       IN DOPENIDM.SOIDM04
;
COMMENT ON TABLE SOPENIDM.MANAGEDOBJECTPROPERTIES IS
'OPENIDM - Properties of Managed Objects';

CREATE UNIQUE INDEX SOPENIDM.IDX_MANAGEDOBJECTPROPERTIES_PROP
       ON SOPENIDM.MANAGEDOBJECTPROPERTIES
       (PROPKEY                      ASC
       ,MANAGEDOBJECTS_ID            ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM05
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE LOB TABLESPACE SOIDM05A
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   LOB
       CLOSE      NO
;
CREATE TABLE SOPENIDM.CONFIGOBJECTS
       (ID                         INTEGER
                                   GENERATED BY DEFAULT
                                   AS IDENTITY
                                   ( CYCLE )
       ,OBJECTTYPES_ID             INTEGER        NOT NULL
       ,OBJECTID                   VARCHAR(255)   NOT NULL
       ,REV                        VARCHAR(38)    NOT NULL
       ,FULLOBJECT                 CLOB(2M)
       ,PRIMARY KEY (ID)
       ,CONSTRAINT FK_CONFIGOBJECTS_OBJECTTYPES
          FOREIGN KEY
         (OBJECTTYPES_ID )
          REFERENCES SOPENIDM.OBJECTTYPES (ID )
         ON DELETE CASCADE
       )
       IN DOPENIDM.SOIDM05
;
COMMENT ON TABLE SOPENIDM.CONFIGOBJECTS IS
'OPENIDM - Generic Table For Config Objects';

CREATE AUXILIARY TABLE SOPENIDM.CONFIGOBJECTS_AUX
       IN DOPENIDM.SOIDM05A
       STORES SOPENIDM.CONFIGOBJECTS
       COLUMN FULLOBJECT
;
COMMENT ON TABLE SOPENIDM.CONFIGOBJECTS_AUX IS
'OPENIDM - Auxiliary table for CONFIGOBJECTS_AUX.FULLOBJECT';

CREATE UNIQUE INDEX SOPENIDM.PK_CONFIGOBJECTS
       ON SOPENIDM.CONFIGOBJECTS
       (ID                           ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE INDEX SOPENIDM.FK_CONFIGOBJECTS_OBJECTTYPES
       ON SOPENIDM.CONFIGOBJECTS
       (OBJECTTYPES_ID               ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE UNIQUE INDEX SOPENIDM.CONFIGOBJECTS_AUX
       ON SOPENIDM.CONFIGOBJECTS_AUX
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM06
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP32K
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE TABLE SOPENIDM.CONFIGOBJECTPROPERTIES
       (CONFIGOBJECTS_ID           INTEGER        NOT NULL
       ,PROPKEY                    VARCHAR(255)   NOT NULL
       ,PROPTYPE                   VARCHAR(32)
       ,PROPVALUE                  VARCHAR(32000)
       ,CONSTRAINT FK_CONFIGOBJECTPROPERTIES_CONFIGOBJECTS
          FOREIGN KEY
         (CONFIGOBJECTS_ID )
          REFERENCES SOPENIDM.CONFIGOBJECTS (ID )
         ON DELETE CASCADE
       )
       IN DOPENIDM.SOIDM06
;
COMMENT ON TABLE SOPENIDM.CONFIGOBJECTPROPERTIES IS
'OPENIDM - Properties of Config Objects';

CREATE UNIQUE INDEX SOPENIDM.IDX_CONFIGOBJECTPROPERTIES_PROP
       ON SOPENIDM.CONFIGOBJECTPROPERTIES
       (PROPKEY                      ASC
       ,CONFIGOBJECTS_ID             ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM07
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE TABLE SOPENIDM.LINKS
       (OBJECTTYPES_ID             INTEGER        NOT NULL
       ,OBJECTID                   VARCHAR(38)    NOT NULL
       ,REV                        VARCHAR(38)    NOT NULL
       ,SOURCEID                   VARCHAR(255)   NOT NULL
       ,TARGETID                   VARCHAR(255)   NOT NULL
       ,PRIMARY KEY (OBJECTTYPES_ID, OBJECTID)
       ,CONSTRAINT FK_CONFIGOBJECTS_OBJECTTYPES
          FOREIGN KEY
         (OBJECTTYPES_ID )
          REFERENCES SOPENIDM.OBJECTTYPES (ID )
         ON DELETE CASCADE
       )
       IN DOPENIDM.SOIDM07
;
COMMENT ON TABLE SOPENIDM.LINKS IS
'OPENIDM - Object Links For Mappings And Synchronization';

CREATE UNIQUE INDEX SOPENIDM.PK_LINKS
       ON SOPENIDM.LINKS
       (OBJECTTYPES_ID               ASC
       ,OBJECTID                     ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE UNIQUE INDEX SOPENIDM.IDX_LINKS_SOURCE
       ON SOPENIDM.LINKS
       (SOURCEID                     ASC
       ,OBJECTTYPES_ID               ASC
       ,OBJECTID                     ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE UNIQUE INDEX SOPENIDM.IDX_LINKS_TARGET
       ON SOPENIDM.LINKS
       (TARGETID                     ASC
       ,OBJECTTYPES_ID               ASC
       ,OBJECTID                     ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM08
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP32K
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE TABLE SOPENIDM.AUDITRECON
       (OBJECTID                   VARCHAR(38)    NOT NULL
       ,RECONID                    VARCHAR(36)
       ,RECONACTION                VARCHAR(36)
       ,RECONCILING                VARCHAR(12)    NOT NULL
       ,SOURCEOBJECTID             VARCHAR(511)
       ,TARGETOBJECTID             VARCHAR(511)
       ,ACTIVITYDATE               VARCHAR(29)    NOT NULL
       ,SITUATION                  VARCHAR(24)
       ,ACTIVITY                   VARCHAR(24)
       ,STATUS                     VARCHAR(7)
       ,MESSAGE                    VARCHAR(30000)
       ,PRIMARY KEY (OBJECTID)
       )
       IN DOPENIDM.SOIDM08
;
COMMENT ON TABLE SOPENIDM.AUDITRECON IS
'OPENIDM - Reconciliation Audit Log';

CREATE UNIQUE INDEX SOPENIDM.PK_AUDITRECON
       ON SOPENIDM.AUDITRECON
       (OBJECTID                     ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM09
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP32K
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE LOB TABLESPACE SOIDM09A
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   LOB
       CLOSE      NO
;
CREATE LOB TABLESPACE SOIDM09B
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP1
       LOCKSIZE   LOB
       CLOSE      NO
;
CREATE TABLE SOPENIDM.AUDITACTIVITY
       (OBJECTID                   VARCHAR(38)    NOT NULL
       ,ACTIVITYDATE               VARCHAR(29)
       ,ACTIVITY                   VARCHAR(24)
       ,MESSAGE                    VARCHAR(30000)
       ,SUBJECTID                  VARCHAR(511)
       ,SUBJECTREV                 VARCHAR(38)
       ,ROOTACTIONID               VARCHAR(512)
       ,PARENTACTIONID             VARCHAR(512)
       ,REQUESTER                  VARCHAR(255)
       ,APPROVER                   VARCHAR(255)
       ,SUBJECTBEFORE              CLOB(2M)
       ,SUBJECTAFTER               CLOB(2M)
       ,STATUS                     VARCHAR(7)
       ,CHANGEDFIELDS              VARCHAR(255)
       ,CHANGEDPASSWORD            VARCHAR(5)
       ,PRIMARY KEY (OBJECTID)
       )
       IN DOPENIDM.SOIDM09
;
COMMENT ON TABLE SOPENIDM.AUDITACTIVITY IS
'OPENIDM - Activity Audit Logs';

CREATE AUXILIARY TABLE SOPENIDM.AUDITACTIVITY_AUX1
       IN DOPENIDM.SOIDM09A
       STORES SOPENIDM.AUDITACTIVITY
       COLUMN SUBJECTBEFORE
;
COMMENT ON TABLE SOPENIDM.AUDITACTIVITY_AUX1 IS
'OPENIDM - Auxiliary table for AUDITACTIVITY_AUX1.SUBJECTBEFORE';

CREATE AUXILIARY TABLE SOPENIDM.AUDITACTIVITY_AUX2
       IN DOPENIDM.SOIDM09B
       STORES SOPENIDM.AUDITACTIVITY
       COLUMN SUBJECTAFTER
;
COMMENT ON TABLE SOPENIDM.AUDITACTIVITY_AUX2 IS
'OPENIDM - Auxiliary table for AUDITACTIVITY_AUX2.SUBJECTAFTER';

CREATE UNIQUE INDEX SOPENIDM.PK_AUDITACTIVITY
       ON SOPENIDM.AUDITACTIVITY
       (OBJECTID                     ASC
       )
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       CLUSTER
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE UNIQUE INDEX SOPENIDM.AUDITACTIVITY_AUX1
       ON SOPENIDM.AUDITACTIVITY_AUX1
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;
CREATE UNIQUE INDEX SOPENIDM.AUDITACTIVITY_AUX2
       ON SOPENIDM.AUDITACTIVITY_AUX2
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP2
       CLOSE      NO
;



CREATE TABLESPACE SOIDM10
       IN         DOPENIDM
       USING STOGROUP GOPENIDM
             PRIQTY   -1
             SECQTY   -1
             ERASE    NO
       BUFFERPOOL BP32K
       LOCKSIZE   ANY
       CLOSE      NO
       SEGSIZE    4
       COMPRESS   YES
;
CREATE TABLE SOPENIDM.AUDITCHANGELOG
       (ACTIVITY                   VARCHAR(24)     NOT NULL
       ,SOURCEOBJECTID             VARCHAR(511)    NOT NULL
       ,ENTRY                      VARCHAR(32000)
       ,ACTIVITYDATE               VARCHAR(29)
       )
       IN DOPENIDM.SOIDM10
;
COMMENT ON TABLE SOPENIDM.AUDITCHANGELOG IS
'OPENIDM - Audit Change Logs';

