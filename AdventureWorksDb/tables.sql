--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

\set errexit false;

 use defaultdb;
 drop database adventureworks cascade;
 create database adventureworks;
 use adventureworks;

--
-- Name: hr; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA hr;


-- ALTER SCHEMA hr OWNER TO root;

--
-- Name: humanresources; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA humanresources;


-- ALTER SCHEMA humanresources OWNER TO root;

--
-- Name: pe; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA pe;


-- ALTER SCHEMA pe OWNER TO root;

--
-- Name: person; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA person;


-- ALTER SCHEMA person OWNER TO root;

--
-- Name: pr; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA pr;


-- ALTER SCHEMA pr OWNER TO root;

--
-- Name: production; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA production;


-- ALTER SCHEMA production OWNER TO root;

--
-- Name: pu; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA pu;


-- ALTER SCHEMA pu OWNER TO root;

--
-- Name: purchasing; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA purchasing;


-- ALTER SCHEMA purchasing OWNER TO root;

--
-- Name: sa; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA sa;


-- ALTER SCHEMA sa OWNER TO root;

--
-- Name: sales; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA sales;


-- ALTER SCHEMA sales OWNER TO root;

--
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

-- CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: AccountNumber; Type: DOMAIN; Schema: public; Owner: root
--

-- CREATE DOMAIN VARCHAR AS character varying(15);


-- ALTER DOMAIN VARCHAR OWNER TO root;

--
-- Name: Flag; Type: DOMAIN; Schema: public; Owner: root
--

-- CREATE DOMAIN boolean AS boolean NOT NULL;


-- ALTER DOMAIN boolean OWNER TO root;

--
-- Name: Name; Type: DOMAIN; Schema: public; Owner: root
--

-- CREATE DOMAIN varcharAS character varying(50);


-- ALTER DOMAIN varcharOWNER TO root;

--
-- Name: NameStyle; Type: DOMAIN; Schema: public; Owner: root
--

-- CREATE DOMAIN boolean AS boolean NOT NULL;


-- ALTER DOMAIN boolean OWNER TO root;

--
-- Name: OrderNumber; Type: DOMAIN; Schema: public; Owner: root
--

-- CREATE DOMAIN varchar  AS character varying(25);


-- ALTER DOMAIN varchar  OWNER TO root;

--
-- Name: Phone; Type: DOMAIN; Schema: public; Owner: root
--

-- CREATE DOMAIN varchar  AS character varying(25);


-- ALTER DOMAIN varchar  OWNER TO root;

-- SET default_tablespace = '';

-- SET default_table_access_method = heap;

--
-- Name: department; Type: TABLE; Schema: humanresources; Owner: root
--

CREATE TABLE humanresources.department (
    departmentid integer NOT NULL,
    name varchar NOT NULL,
    groupname varchar NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE humanresources.department OWNER TO root;

--
-- Name: d; Type: VIEW; Schema: hr; Owner: root
--

CREATE VIEW hr.d AS
 SELECT department.departmentid AS id,
    department.departmentid,
    department.name,
    department.groupname,
    department.modifieddate
   FROM humanresources.department;


ALTER TABLE hr.d OWNER TO root;

--
-- Name: employee; Type: TABLE; Schema: humanresources; Owner: root
--

CREATE TABLE humanresources.employee (
    businessentityid integer NOT NULL, 
    nationalidnumber character varying(15) NOT NULL,
    loginid character varying(256) NOT NULL,
    jobtitle character varying(50) NOT NULL,
    birthdate date NOT NULL,
    maritalstatus character(1) NOT NULL,
    gender character(1) NOT NULL,
    hiredate date NOT NULL,
    salariedflag boolean DEFAULT true NOT NULL,
    vacationhours smallint DEFAULT 0 NOT NULL,
    sickleavehours smallint DEFAULT 0 NOT NULL,
    currentflag boolean DEFAULT true NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    organizationnode character varying DEFAULT '/'::character varying,
    CONSTRAINT "CK_Employee_BirthDate" CHECK (((birthdate >= '1930-01-01'::date) AND (birthdate <= (now() - '18 years'::interval)))),
    CONSTRAINT "CK_Employee_Gender" CHECK ((upper((gender)::text) = ANY (ARRAY['M'::text, 'F'::text]))),
    CONSTRAINT "CK_Employee_HireDate" CHECK (((hiredate >= '1996-07-01'::date) AND (hiredate <= (now() + '1 day'::interval)))),
    CONSTRAINT "CK_Employee_MaritalStatus" CHECK ((upper((maritalstatus)::text) = ANY (ARRAY['M'::text, 'S'::text]))),
    CONSTRAINT "CK_Employee_SickLeaveHours" CHECK (((sickleavehours >= 0) AND (sickleavehours <= 120))),
    CONSTRAINT "CK_Employee_VacationHours" CHECK (((vacationhours >= '-40'::integer) AND (vacationhours <= 240)))
);


ALTER TABLE humanresources.employee OWNER TO root;

--
-- Name: e; Type: VIEW; Schema: hr; Owner: root
--

CREATE VIEW hr.e AS
 SELECT employee.businessentityid AS id,
    employee.businessentityid,
    employee.nationalidnumber,
    employee.loginid,
    employee.jobtitle,
    employee.birthdate,
    employee.maritalstatus,
    employee.gender,
    employee.hiredate,
    employee.salariedflag,
    employee.vacationhours,
    employee.sickleavehours,
    employee.currentflag,
    employee.rowguid,
    employee.modifieddate,
    employee.organizationnode
   FROM humanresources.employee;


ALTER TABLE hr.e OWNER TO root;

--
-- Name: employeedepartmenthistory; Type: TABLE; Schema: humanresources; Owner: root
--

CREATE TABLE humanresources.employeedepartmenthistory (
    businessentityid integer NOT NULL,
    departmentid smallint NOT NULL,
    shiftid smallint NOT NULL,
    startdate date NOT NULL,
    enddate date,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_EmployeeDepartmentHistory_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL)))
);


ALTER TABLE humanresources.employeedepartmenthistory OWNER TO root;

--
-- Name: edh; Type: VIEW; Schema: hr; Owner: root
--

CREATE VIEW hr.edh AS
 SELECT employeedepartmenthistory.businessentityid AS id,
    employeedepartmenthistory.businessentityid,
    employeedepartmenthistory.departmentid,
    employeedepartmenthistory.shiftid,
    employeedepartmenthistory.startdate,
    employeedepartmenthistory.enddate,
    employeedepartmenthistory.modifieddate
   FROM humanresources.employeedepartmenthistory;


ALTER TABLE hr.edh OWNER TO root;

--
-- Name: employeepayhistory; Type: TABLE; Schema: humanresources; Owner: root
--

CREATE TABLE humanresources.employeepayhistory (
    businessentityid integer NOT NULL,
    ratechangedate timestamp without time zone NOT NULL,
    rate numeric NOT NULL,
    payfrequency smallint NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_EmployeePayHistory_PayFrequency" CHECK ((payfrequency = ANY (ARRAY[1, 2]))),
    CONSTRAINT "CK_EmployeePayHistory_Rate" CHECK (((rate >= 6.50) AND (rate <= 200.00)))
);


ALTER TABLE humanresources.employeepayhistory OWNER TO root;

--
-- Name: eph; Type: VIEW; Schema: hr; Owner: root
--

CREATE VIEW hr.eph AS
 SELECT employeepayhistory.businessentityid AS id,
    employeepayhistory.businessentityid,
    employeepayhistory.ratechangedate,
    employeepayhistory.rate,
    employeepayhistory.payfrequency,
    employeepayhistory.modifieddate
   FROM humanresources.employeepayhistory;


ALTER TABLE hr.eph OWNER TO root;

--
-- Name: jobcandidate; Type: TABLE; Schema: humanresources; Owner: root
--

CREATE TABLE humanresources.jobcandidate (
    jobcandidateid integer NOT NULL,
    businessentityid integer,
    resume VARCHAR,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE humanresources.jobcandidate OWNER TO root;

--
-- Name: jc; Type: VIEW; Schema: hr; Owner: root
--

CREATE VIEW hr.jc AS
 SELECT jobcandidate.jobcandidateid AS id,
    jobcandidate.jobcandidateid,
    jobcandidate.businessentityid,
    jobcandidate.resume,
    jobcandidate.modifieddate
   FROM humanresources.jobcandidate;


ALTER TABLE hr.jc OWNER TO root;

--
-- Name: shift; Type: TABLE; Schema: humanresources; Owner: root
--

CREATE TABLE humanresources.shift (
    shiftid integer NOT NULL,
    name varchar NOT NULL,
    starttime time without time zone NOT NULL,
    endtime time without time zone NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE humanresources.shift OWNER TO root;

--
-- Name: s; Type: VIEW; Schema: hr; Owner: root
--

CREATE VIEW hr.s AS
 SELECT shift.shiftid AS id,
    shift.shiftid,
    shift.name,
    shift.starttime,
    shift.endtime,
    shift.modifieddate
   FROM humanresources.shift;


ALTER TABLE hr.s OWNER TO root;

--
-- Name: department_departmentid_seq; Type: SEQUENCE; Schema: humanresources; Owner: root
--

CREATE SEQUENCE humanresources.department_departmentid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE humanresources.department_departmentid_seq OWNER TO root;

--
-- Name: department_departmentid_seq; Type: SEQUENCE OWNED BY; Schema: humanresources; Owner: root
--

ALTER SEQUENCE humanresources.department_departmentid_seq OWNED BY humanresources.department.departmentid;


--
-- Name: jobcandidate_jobcandidateid_seq; Type: SEQUENCE; Schema: humanresources; Owner: root
--

CREATE SEQUENCE humanresources.jobcandidate_jobcandidateid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE humanresources.jobcandidate_jobcandidateid_seq OWNER TO root;

--
-- Name: jobcandidate_jobcandidateid_seq; Type: SEQUENCE OWNED BY; Schema: humanresources; Owner: root
--

ALTER SEQUENCE humanresources.jobcandidate_jobcandidateid_seq OWNED BY humanresources.jobcandidate.jobcandidateid;


--
-- Name: shift_shiftid_seq; Type: SEQUENCE; Schema: humanresources; Owner: root
--

CREATE SEQUENCE humanresources.shift_shiftid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE humanresources.shift_shiftid_seq OWNER TO root;

--
-- Name: shift_shiftid_seq; Type: SEQUENCE OWNED BY; Schema: humanresources; Owner: root
--

ALTER SEQUENCE humanresources.shift_shiftid_seq OWNED BY humanresources.shift.shiftid;


--
-- Name: address; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.address (
    addressid integer NOT NULL,
    addressline1 character varying(60) NOT NULL,
    addressline2 character varying(60),
    city character varying(30) NOT NULL,
    stateprovinceid integer NOT NULL,
    postalcode character varying(15) NOT NULL,
    spatiallocation character varying(44),
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.address OWNER TO root;

--
-- Name: businessentityaddress; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.businessentityaddress (
    businessentityid integer NOT NULL,
    addressid integer NOT NULL,
    addresstypeid integer NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.businessentityaddress OWNER TO root;

--
-- Name: countryregion; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.countryregion (
    countryregioncode character varying(3) NOT NULL,
    name varchar NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.countryregion OWNER TO root;

--
-- Name: emailaddress; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.emailaddress (
    businessentityid integer NOT NULL,
    emailaddressid integer NOT NULL,
    emailaddress character varying(50),
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.emailaddress OWNER TO root;

--
-- Name: person; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.person (
    businessentityid integer NOT NULL,
    persontype character(2) NOT NULL,
    namestyle boolean DEFAULT false NOT NULL,
    title character varying(8),
    firstname varchar NOT NULL,
    middlename VARCHAR,
    lastname varchar NOT NULL,
    suffix character varying(10),
    emailpromotion integer DEFAULT 0 NOT NULL,
    additionalcontactinfo VARCHAR,
    demographics VARCHAR,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_Person_EmailPromotion" CHECK (((emailpromotion >= 0) AND (emailpromotion <= 2))),
    CONSTRAINT "CK_Person_PersonType" CHECK (((persontype IS NULL) OR (upper((persontype)::text) = ANY (ARRAY['SC'::text, 'VC'::text, 'IN'::text, 'EM'::text, 'SP'::text, 'GC'::text]))))
);


ALTER TABLE person.person OWNER TO root;

--
-- Name: personphone; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.personphone (
    businessentityid integer NOT NULL,
    phonenumber varchar  NOT NULL,
    phonenumbertypeid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.personphone OWNER TO root;

--
-- Name: phonenumbertype; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.phonenumbertype (
    phonenumbertypeid integer NOT NULL,
    name varchar NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.phonenumbertype OWNER TO root;

--
-- Name: stateprovince; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.stateprovince (
    stateprovinceid integer NOT NULL,
    stateprovincecode character(3) NOT NULL,
    countryregioncode character varying(3) NOT NULL,
    isonlystateprovinceflag boolean DEFAULT true NOT NULL,
    name varchar NOT NULL,
    territoryid integer NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.stateprovince OWNER TO root;

--
-- Name: vemployee; Type: VIEW; Schema: humanresources; Owner: root
--

CREATE VIEW humanresources.vemployee AS
 SELECT e.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    e.jobtitle,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname,
    p.additionalcontactinfo
   FROM ((((((((humanresources.employee e
     JOIN person.person p ON ((p.businessentityid = e.businessentityid)))
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = e.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pp.phonenumbertypeid = pnt.phonenumbertypeid)))
     LEFT JOIN person.emailaddress ea ON ((p.businessentityid = ea.businessentityid)));


ALTER TABLE humanresources.vemployee OWNER TO root;

--
-- Name: vemployeedepartment; Type: VIEW; Schema: humanresources; Owner: root
--

CREATE VIEW humanresources.vemployeedepartment AS
 SELECT e.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    e.jobtitle,
    d.name AS department,
    d.groupname,
    edh.startdate
   FROM (((humanresources.employee e
     JOIN person.person p ON ((p.businessentityid = e.businessentityid)))
     JOIN humanresources.employeedepartmenthistory edh ON ((e.businessentityid = edh.businessentityid)))
     JOIN humanresources.department d ON ((edh.departmentid = d.departmentid)))
  WHERE (edh.enddate IS NULL);


ALTER TABLE humanresources.vemployeedepartment OWNER TO root;

--
-- Name: vemployeedepartmenthistory; Type: VIEW; Schema: humanresources; Owner: root
--

CREATE VIEW humanresources.vemployeedepartmenthistory AS
 SELECT e.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    s.name AS shift,
    d.name AS department,
    d.groupname,
    edh.startdate,
    edh.enddate
   FROM ((((humanresources.employee e
     JOIN person.person p ON ((p.businessentityid = e.businessentityid)))
     JOIN humanresources.employeedepartmenthistory edh ON ((e.businessentityid = edh.businessentityid)))
     JOIN humanresources.department d ON ((edh.departmentid = d.departmentid)))
     JOIN humanresources.shift s ON ((s.shiftid = edh.shiftid)));


ALTER TABLE humanresources.vemployeedepartmenthistory OWNER TO root;

--
-- Name: vjobcandidate; Type: VIEW; Schema: humanresources; Owner: root
--

 


ALTER TABLE humanresources.vjobcandidate OWNER TO root;

--
-- Name: vjobcandidateeducation; Type: VIEW; Schema: humanresources; Owner: root
--

 


ALTER TABLE humanresources.vjobcandidateeducation OWNER TO root;

--
-- Name: vjobcandidateemployment; Type: VIEW; Schema: humanresources; Owner: root
--

 


ALTER TABLE humanresources.vjobcandidateemployment OWNER TO root;

--
-- Name: a; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.a AS
 SELECT address.addressid AS id,
    address.addressid,
    address.addressline1,
    address.addressline2, 
    address.city,
    address.stateprovinceid,
    address.postalcode,
    address.spatiallocation,
    address.rowguid,
    address.modifieddate
   FROM person.address;


ALTER TABLE pe.a OWNER TO root;

--
-- Name: addresstype; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.addresstype (
    addresstypeid integer NOT NULL,
    name varchar NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.addresstype OWNER TO root;

--
-- Name: at; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.at AS
 SELECT addresstype.addresstypeid AS id,
    addresstype.addresstypeid,
    addresstype.name,
    addresstype.rowguid,
    addresstype.modifieddate
   FROM person.addresstype;


ALTER TABLE pe.at OWNER TO root;

--
-- Name: businessentity; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.businessentity (
    businessentityid integer NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.businessentity OWNER TO root;

--
-- Name: be; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.be AS
 SELECT businessentity.businessentityid AS id,
    businessentity.businessentityid,
    businessentity.rowguid,
    businessentity.modifieddate
   FROM person.businessentity;


ALTER TABLE pe.be OWNER TO root;

--
-- Name: bea; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.bea AS
 SELECT businessentityaddress.businessentityid AS id,
    businessentityaddress.businessentityid,
    businessentityaddress.addressid,
    businessentityaddress.addresstypeid,
    businessentityaddress.rowguid,
    businessentityaddress.modifieddate
   FROM person.businessentityaddress;


ALTER TABLE pe.bea OWNER TO root;

--
-- Name: businessentitycontact; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.businessentitycontact (
    businessentityid integer NOT NULL,
    personid integer NOT NULL,
    contacttypeid integer NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.businessentitycontact OWNER TO root;

--
-- Name: bec; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.bec AS
 SELECT businessentitycontact.businessentityid AS id,
    businessentitycontact.businessentityid,
    businessentitycontact.personid,
    businessentitycontact.contacttypeid,
    businessentitycontact.rowguid,
    businessentitycontact.modifieddate
   FROM person.businessentitycontact;


ALTER TABLE pe.bec OWNER TO root;

--
-- Name: cr; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.cr AS
 SELECT countryregion.countryregioncode,
    countryregion.name,
    countryregion.modifieddate
   FROM person.countryregion;


ALTER TABLE pe.cr OWNER TO root;

--
-- Name: contacttype; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.contacttype (
    contacttypeid integer NOT NULL,
    name varchar NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.contacttype OWNER TO root;

--
-- Name: ct; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.ct AS
 SELECT contacttype.contacttypeid AS id,
    contacttype.contacttypeid,
    contacttype.name,
    contacttype.modifieddate
   FROM person.contacttype;


ALTER TABLE pe.ct OWNER TO root;

--
-- Name: e; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.e AS
 SELECT emailaddress.emailaddressid AS id,
    emailaddress.businessentityid,
    emailaddress.emailaddressid,
    emailaddress.emailaddress,
    emailaddress.rowguid,
    emailaddress.modifieddate
   FROM person.emailaddress;


ALTER TABLE pe.e OWNER TO root;

--
-- Name: p; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.p AS
 SELECT person.businessentityid AS id,
    person.businessentityid,
    person.persontype,
    person.namestyle,
    person.title,
    person.firstname,
    person.middlename,
    person.lastname,
    person.suffix,
    person.emailpromotion,
    person.additionalcontactinfo,
    person.demographics,
    person.rowguid,
    person.modifieddate
   FROM person.person;


ALTER TABLE pe.p OWNER TO root;

--
-- Name: password; Type: TABLE; Schema: person; Owner: root
--

CREATE TABLE person.password (
    businessentityid integer NOT NULL,
    passwordhash character varying(128) NOT NULL,
    passwordsalt character varying(10) NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE person.password OWNER TO root;

--
-- Name: pa; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.pa AS
 SELECT password.businessentityid AS id,
    password.businessentityid,
    password.passwordhash,
    password.passwordsalt,
    password.rowguid,
    password.modifieddate
   FROM person.password;


ALTER TABLE pe.pa OWNER TO root;

--
-- Name: pnt; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.pnt AS
 SELECT phonenumbertype.phonenumbertypeid AS id,
    phonenumbertype.phonenumbertypeid,
    phonenumbertype.name,
    phonenumbertype.modifieddate
   FROM person.phonenumbertype;


ALTER TABLE pe.pnt OWNER TO root;

--
-- Name: pp; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.pp AS
 SELECT personphone.businessentityid AS id,
    personphone.businessentityid,
    personphone.phonenumber,
    personphone.phonenumbertypeid,
    personphone.modifieddate
   FROM person.personphone;


ALTER TABLE pe.pp OWNER TO root;

--
-- Name: sp; Type: VIEW; Schema: pe; Owner: root
--

CREATE VIEW pe.sp AS
 SELECT stateprovince.stateprovinceid AS id,
    stateprovince.stateprovinceid,
    stateprovince.stateprovincecode,
    stateprovince.countryregioncode,
    stateprovince.isonlystateprovinceflag,
    stateprovince.name,
    stateprovince.territoryid,
    stateprovince.rowguid,
    stateprovince.modifieddate
   FROM person.stateprovince;


ALTER TABLE pe.sp OWNER TO root;

--
-- Name: address_addressid_seq; Type: SEQUENCE; Schema: person; Owner: root
--

CREATE SEQUENCE person.address_addressid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.address_addressid_seq OWNER TO root;

--
-- Name: address_addressid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: root
--

ALTER SEQUENCE person.address_addressid_seq OWNED BY person.address.addressid;


--
-- Name: addresstype_addresstypeid_seq; Type: SEQUENCE; Schema: person; Owner: root
--

CREATE SEQUENCE person.addresstype_addresstypeid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.addresstype_addresstypeid_seq OWNER TO root;

--
-- Name: addresstype_addresstypeid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: root
--

ALTER SEQUENCE person.addresstype_addresstypeid_seq OWNED BY person.addresstype.addresstypeid;


--
-- Name: businessentity_businessentityid_seq; Type: SEQUENCE; Schema: person; Owner: root
--

CREATE SEQUENCE person.businessentity_businessentityid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.businessentity_businessentityid_seq OWNER TO root;

--
-- Name: businessentity_businessentityid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: root
--

ALTER SEQUENCE person.businessentity_businessentityid_seq OWNED BY person.businessentity.businessentityid;


--
-- Name: contacttype_contacttypeid_seq; Type: SEQUENCE; Schema: person; Owner: root
--

CREATE SEQUENCE person.contacttype_contacttypeid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.contacttype_contacttypeid_seq OWNER TO root;

--
-- Name: contacttype_contacttypeid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: root
--

ALTER SEQUENCE person.contacttype_contacttypeid_seq OWNED BY person.contacttype.contacttypeid;


--
-- Name: emailaddress_emailaddressid_seq; Type: SEQUENCE; Schema: person; Owner: root
--

CREATE SEQUENCE person.emailaddress_emailaddressid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.emailaddress_emailaddressid_seq OWNER TO root;

--
-- Name: emailaddress_emailaddressid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: root
--

ALTER SEQUENCE person.emailaddress_emailaddressid_seq OWNED BY person.emailaddress.emailaddressid;


--
-- Name: phonenumbertype_phonenumbertypeid_seq; Type: SEQUENCE; Schema: person; Owner: root
--

CREATE SEQUENCE person.phonenumbertype_phonenumbertypeid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.phonenumbertype_phonenumbertypeid_seq OWNER TO root;

--
-- Name: phonenumbertype_phonenumbertypeid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: root
--

ALTER SEQUENCE person.phonenumbertype_phonenumbertypeid_seq OWNED BY person.phonenumbertype.phonenumbertypeid;


--
-- Name: stateprovince_stateprovinceid_seq; Type: SEQUENCE; Schema: person; Owner: root
--

CREATE SEQUENCE person.stateprovince_stateprovinceid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person.stateprovince_stateprovinceid_seq OWNER TO root;

--
-- Name: stateprovince_stateprovinceid_seq; Type: SEQUENCE OWNED BY; Schema: person; Owner: root
--

ALTER SEQUENCE person.stateprovince_stateprovinceid_seq OWNED BY person.stateprovince.stateprovinceid;


--
-- Name: vadditionalcontactinfo; Type: VIEW; Schema: person; Owner: root
--

 
--
-- Name: vstateprovincecountryregion; Type: MATERIALIZED VIEW; Schema: person; Owner: root
--

CREATE MATERIALIZED VIEW person.vstateprovincecountryregion AS
 SELECT sp.stateprovinceid,
    sp.stateprovincecode,
    sp.isonlystateprovinceflag,
    sp.name AS stateprovincename,
    sp.territoryid,
    cr.countryregioncode,
    cr.name AS countryregionname
   FROM (person.stateprovince sp
     JOIN person.countryregion cr ON (((sp.countryregioncode)::text = (cr.countryregioncode)::text)))
  ;


ALTER TABLE person.vstateprovincecountryregion OWNER TO root;

--
-- Name: billofmaterials; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.billofmaterials (
    billofmaterialsid integer NOT NULL,
    productassemblyid integer,
    componentid integer NOT NULL,
    startdate timestamp without time zone DEFAULT now() NOT NULL,
    enddate timestamp without time zone,
    unitmeasurecode character(3) NOT NULL,
    bomlevel smallint NOT NULL,
    perassemblyqty numeric(8,2) DEFAULT 1.00 NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_BillOfMaterials_BOMLevel" CHECK ((((productassemblyid IS NULL) AND (bomlevel = 0) AND (perassemblyqty = 1.00)) OR ((productassemblyid IS NOT NULL) AND (bomlevel >= 1)))),
    CONSTRAINT "CK_BillOfMaterials_EndDate" CHECK (((enddate > startdate) OR (enddate IS NULL))),
    CONSTRAINT "CK_BillOfMaterials_PerAssemblyQty" CHECK ((perassemblyqty >= 1.00)),
    CONSTRAINT "CK_BillOfMaterials_ProductAssemblyID" CHECK ((productassemblyid <> componentid))
);


ALTER TABLE production.billofmaterials OWNER TO root;

--
-- Name: bom; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.bom AS
 SELECT billofmaterials.billofmaterialsid AS id,
    billofmaterials.billofmaterialsid,
    billofmaterials.productassemblyid,
    billofmaterials.componentid,
    billofmaterials.startdate,
    billofmaterials.enddate,
    billofmaterials.unitmeasurecode,
    billofmaterials.bomlevel,
    billofmaterials.perassemblyqty,
    billofmaterials.modifieddate
   FROM production.billofmaterials;


ALTER TABLE pr.bom OWNER TO root;

--
-- Name: culture; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.culture (
    cultureid character(6) NOT NULL,
    name varchar NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.culture OWNER TO root;

--
-- Name: c; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.c AS
 SELECT culture.cultureid AS id,
    culture.cultureid,
    culture.name,
    culture.modifieddate
   FROM production.culture;


ALTER TABLE pr.c OWNER TO root;

--
-- Name: document; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.document (
    title character varying(50) NOT NULL,
    owner integer NOT NULL,
    folderflag boolean DEFAULT false NOT NULL,
    filename character varying(400) NOT NULL,
    fileextension character varying(8),
    revision character(5) NOT NULL,
    changenumber integer DEFAULT 0 NOT NULL,
    status smallint NOT NULL,
    documentsummary text,
    document bytea,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    documentnode character varying DEFAULT '/'::character varying NOT NULL,
    CONSTRAINT "CK_Document_Status" CHECK (((status >= 1) AND (status <= 3)))
);


ALTER TABLE production.document OWNER TO root;

--
-- Name: d; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.d AS
 SELECT document.title,
    document.owner,
    document.folderflag,
    document.filename,
    document.fileextension,
    document.revision,
    document.changenumber,
    document.status,
    document.documentsummary,
    document.document,
    document.rowguid,
    document.modifieddate,
    document.documentnode
   FROM production.document;


ALTER TABLE pr.d OWNER TO root;

--
-- Name: illustration; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.illustration (
    illustrationid integer NOT NULL,
    diagram VARCHAR,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.illustration OWNER TO root;

--
-- Name: i; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.i AS
 SELECT illustration.illustrationid AS id,
    illustration.illustrationid,
    illustration.diagram,
    illustration.modifieddate
   FROM production.illustration;


ALTER TABLE pr.i OWNER TO root;

--
-- Name: location; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.location (
    locationid integer NOT NULL,
    name varchar NOT NULL,
    costrate numeric DEFAULT 0.00 NOT NULL,
    availability numeric(8,2) DEFAULT 0.00 NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_Location_Availability" CHECK ((availability >= 0.00)),
    CONSTRAINT "CK_Location_CostRate" CHECK ((costrate >= 0.00))
);


ALTER TABLE production.location OWNER TO root;

--
-- Name: l; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.l AS
 SELECT location.locationid AS id,
    location.locationid,
    location.name,
    location.costrate,
    location.availability,
    location.modifieddate
   FROM production.location;


ALTER TABLE pr.l OWNER TO root;

--
-- Name: product; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.product (
    productid integer NOT NULL,
    name varchar NOT NULL,
    productnumber character varying(25) NOT NULL,
    makeflag boolean DEFAULT true NOT NULL,
    finishedgoodsflag boolean DEFAULT true NOT NULL,
    color character varying(15),
    safetystocklevel smallint NOT NULL,
    reorderpoint smallint NOT NULL,
    standardcost numeric NOT NULL,
    listprice numeric NOT NULL,
    size character varying(5),
    sizeunitmeasurecode character(3),
    weightunitmeasurecode character(3),
    weight numeric(8,2),
    daystomanufacture integer NOT NULL,
    productline character(2),
    class character(2),
    style character(2),
    productsubcategoryid integer,
    productmodelid integer,
    sellstartdate timestamp without time zone NOT NULL,
    sellenddate timestamp without time zone,
    discontinueddate timestamp without time zone,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_Product_Class" CHECK (((upper((class)::text) = ANY (ARRAY['L'::text, 'M'::text, 'H'::text])) OR (class IS NULL))),
    CONSTRAINT "CK_Product_DaysToManufacture" CHECK ((daystomanufacture >= 0)),
    CONSTRAINT "CK_Product_ListPrice" CHECK ((listprice >= 0.00)),
    CONSTRAINT "CK_Product_ProductLine" CHECK (((upper((productline)::text) = ANY (ARRAY['S'::text, 'T'::text, 'M'::text, 'R'::text])) OR (productline IS NULL))),
    CONSTRAINT "CK_Product_ReorderPoint" CHECK ((reorderpoint > 0)),
    CONSTRAINT "CK_Product_SafetyStockLevel" CHECK ((safetystocklevel > 0)),
    CONSTRAINT "CK_Product_SellEndDate" CHECK (((sellenddate >= sellstartdate) OR (sellenddate IS NULL))),
    CONSTRAINT "CK_Product_StandardCost" CHECK ((standardcost >= 0.00)),
    CONSTRAINT "CK_Product_Style" CHECK (((upper((style)::text) = ANY (ARRAY['W'::text, 'M'::text, 'U'::text])) OR (style IS NULL))),
    CONSTRAINT "CK_Product_Weight" CHECK ((weight > 0.00))
);


ALTER TABLE production.product OWNER TO root;

--
-- Name: p; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.p AS
 SELECT product.productid AS id,
    product.productid,
    product.name,
    product.productnumber,
    product.makeflag,
    product.finishedgoodsflag,
    product.color,
    product.safetystocklevel,
    product.reorderpoint,
    product.standardcost,
    product.listprice,
    product.size,
    product.sizeunitmeasurecode,
    product.weightunitmeasurecode,
    product.weight,
    product.daystomanufacture,
    product.productline,
    product.class,
    product.style,
    product.productsubcategoryid,
    product.productmodelid,
    product.sellstartdate,
    product.sellenddate,
    product.discontinueddate,
    product.rowguid,
    product.modifieddate
   FROM production.product;


ALTER TABLE pr.p OWNER TO root;

--
-- Name: productcategory; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productcategory (
    productcategoryid integer NOT NULL,
    name varchar NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productcategory OWNER TO root;

--
-- Name: pc; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pc AS
 SELECT productcategory.productcategoryid AS id,
    productcategory.productcategoryid,
    productcategory.name,
    productcategory.rowguid,
    productcategory.modifieddate
   FROM production.productcategory;


ALTER TABLE pr.pc OWNER TO root;

--
-- Name: productcosthistory; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productcosthistory (
    productid integer NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone,
    standardcost numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductCostHistory_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL))),
    CONSTRAINT "CK_ProductCostHistory_StandardCost" CHECK ((standardcost >= 0.00))
);


ALTER TABLE production.productcosthistory OWNER TO root;

--
-- Name: pch; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pch AS
 SELECT productcosthistory.productid AS id,
    productcosthistory.productid,
    productcosthistory.startdate,
    productcosthistory.enddate,
    productcosthistory.standardcost,
    productcosthistory.modifieddate
   FROM production.productcosthistory;


ALTER TABLE pr.pch OWNER TO root;

--
-- Name: productdescription; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productdescription (
    productdescriptionid integer NOT NULL,
    description character varying(400) NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productdescription OWNER TO root;

--
-- Name: pd; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pd AS
 SELECT productdescription.productdescriptionid AS id,
    productdescription.productdescriptionid,
    productdescription.description,
    productdescription.rowguid,
    productdescription.modifieddate
   FROM production.productdescription;


ALTER TABLE pr.pd OWNER TO root;

--
-- Name: productdocument; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productdocument (
    productid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    documentnode character varying DEFAULT '/'::character varying NOT NULL
);


ALTER TABLE production.productdocument OWNER TO root;

--
-- Name: pdoc; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pdoc AS
 SELECT productdocument.productid AS id,
    productdocument.productid,
    productdocument.modifieddate,
    productdocument.documentnode
   FROM production.productdocument;


ALTER TABLE pr.pdoc OWNER TO root;

--
-- Name: productinventory; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productinventory (
    productid integer NOT NULL,
    locationid smallint NOT NULL,
    shelf character varying(10) NOT NULL,
    bin smallint NOT NULL,
    quantity smallint DEFAULT 0 NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductInventory_Bin" CHECK (((bin >= 0) AND (bin <= 100)))
);


ALTER TABLE production.productinventory OWNER TO root;

--
-- Name: pi; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pi AS
 SELECT productinventory.productid AS id,
    productinventory.productid,
    productinventory.locationid,
    productinventory.shelf,
    productinventory.bin,
    productinventory.quantity,
    productinventory.rowguid,
    productinventory.modifieddate
   FROM production.productinventory;


ALTER TABLE pr.pi OWNER TO root;

--
-- Name: productlistpricehistory; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productlistpricehistory (
    productid integer NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone,
    listprice numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductListPriceHistory_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL))),
    CONSTRAINT "CK_ProductListPriceHistory_ListPrice" CHECK ((listprice > 0.00))
);


ALTER TABLE production.productlistpricehistory OWNER TO root;

--
-- Name: plph; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.plph AS
 SELECT productlistpricehistory.productid AS id,
    productlistpricehistory.productid,
    productlistpricehistory.startdate,
    productlistpricehistory.enddate,
    productlistpricehistory.listprice,
    productlistpricehistory.modifieddate
   FROM production.productlistpricehistory;


ALTER TABLE pr.plph OWNER TO root;

--
-- Name: productmodel; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productmodel (
    productmodelid integer NOT NULL,
    name varchar NOT NULL,
    catalogdescription VARCHAR,
    instructions VARCHAR,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productmodel OWNER TO root;

--
-- Name: pm; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pm AS
 SELECT productmodel.productmodelid AS id,
    productmodel.productmodelid,
    productmodel.name,
    productmodel.catalogdescription,
    productmodel.instructions,
    productmodel.rowguid,
    productmodel.modifieddate
   FROM production.productmodel;


ALTER TABLE pr.pm OWNER TO root;

--
-- Name: productmodelillustration; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productmodelillustration (
    productmodelid integer NOT NULL,
    illustrationid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productmodelillustration OWNER TO root;

--
-- Name: pmi; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pmi AS
 SELECT productmodelillustration.productmodelid,
    productmodelillustration.illustrationid,
    productmodelillustration.modifieddate
   FROM production.productmodelillustration;


ALTER TABLE pr.pmi OWNER TO root;

--
-- Name: productmodelproductdescriptionculture; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productmodelproductdescriptionculture (
    productmodelid integer NOT NULL,
    productdescriptionid integer NOT NULL,
    cultureid character(6) NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productmodelproductdescriptionculture OWNER TO root;

--
-- Name: pmpdc; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pmpdc AS
 SELECT productmodelproductdescriptionculture.productmodelid,
    productmodelproductdescriptionculture.productdescriptionid,
    productmodelproductdescriptionculture.cultureid,
    productmodelproductdescriptionculture.modifieddate
   FROM production.productmodelproductdescriptionculture;


ALTER TABLE pr.pmpdc OWNER TO root;

--
-- Name: productphoto; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productphoto (
    productphotoid integer NOT NULL,
    thumbnailphoto bytea,
    thumbnailphotofilename character varying(50),
    largephoto bytea,
    largephotofilename character varying(50),
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productphoto OWNER TO root;

--
-- Name: pp; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pp AS
 SELECT productphoto.productphotoid AS id,
    productphoto.productphotoid,
    productphoto.thumbnailphoto,
    productphoto.thumbnailphotofilename,
    productphoto.largephoto,
    productphoto.largephotofilename,
    productphoto.modifieddate
   FROM production.productphoto;


ALTER TABLE pr.pp OWNER TO root;

--
-- Name: productproductphoto; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productproductphoto (
    productid integer NOT NULL,
    productphotoid integer NOT NULL,
    "primary" boolean DEFAULT false NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productproductphoto OWNER TO root;

--
-- Name: ppp; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.ppp AS
 SELECT productproductphoto.productid,
    productproductphoto.productphotoid,
    productproductphoto."primary",
    productproductphoto.modifieddate
   FROM production.productproductphoto;


ALTER TABLE pr.ppp OWNER TO root;

--
-- Name: productreview; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productreview (
    productreviewid integer NOT NULL,
    productid integer NOT NULL,
    reviewername varchar NOT NULL,
    reviewdate timestamp without time zone DEFAULT now() NOT NULL,
    emailaddress character varying(50) NOT NULL,
    rating integer NOT NULL,
    comments character varying(3850),
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductReview_Rating" CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE production.productreview OWNER TO root;

--
-- Name: pr; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.pr AS
 SELECT productreview.productreviewid AS id,
    productreview.productreviewid,
    productreview.productid,
    productreview.reviewername,
    productreview.reviewdate,
    productreview.emailaddress,
    productreview.rating,
    productreview.comments,
    productreview.modifieddate
   FROM production.productreview;


ALTER TABLE pr.pr OWNER TO root;

--
-- Name: productsubcategory; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.productsubcategory (
    productsubcategoryid integer NOT NULL,
    productcategoryid integer NOT NULL,
    name varchar NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.productsubcategory OWNER TO root;

--
-- Name: psc; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.psc AS
 SELECT productsubcategory.productsubcategoryid AS id,
    productsubcategory.productsubcategoryid,
    productsubcategory.productcategoryid,
    productsubcategory.name,
    productsubcategory.rowguid,
    productsubcategory.modifieddate
   FROM production.productsubcategory;


ALTER TABLE pr.psc OWNER TO root;

--
-- Name: scrapreason; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.scrapreason (
    scrapreasonid integer NOT NULL,
    name varchar NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.scrapreason OWNER TO root;

--
-- Name: sr; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.sr AS
 SELECT scrapreason.scrapreasonid AS id,
    scrapreason.scrapreasonid,
    scrapreason.name,
    scrapreason.modifieddate
   FROM production.scrapreason;


ALTER TABLE pr.sr OWNER TO root;

--
-- Name: transactionhistory; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.transactionhistory (
    transactionid integer NOT NULL,
    productid integer NOT NULL,
    referenceorderid integer NOT NULL,
    referenceorderlineid integer DEFAULT 0 NOT NULL,
    transactiondate timestamp without time zone DEFAULT now() NOT NULL,
    transactiontype character(1) NOT NULL,
    quantity integer NOT NULL,
    actualcost numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_TransactionHistory_TransactionType" CHECK ((upper((transactiontype)::text) = ANY (ARRAY['W'::text, 'S'::text, 'P'::text])))
);


ALTER TABLE production.transactionhistory OWNER TO root;

--
-- Name: th; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.th AS
 SELECT transactionhistory.transactionid AS id,
    transactionhistory.transactionid,
    transactionhistory.productid,
    transactionhistory.referenceorderid,
    transactionhistory.referenceorderlineid,
    transactionhistory.transactiondate,
    transactionhistory.transactiontype,
    transactionhistory.quantity,
    transactionhistory.actualcost,
    transactionhistory.modifieddate
   FROM production.transactionhistory;


ALTER TABLE pr.th OWNER TO root;

--
-- Name: transactionhistoryarchive; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.transactionhistoryarchive (
    transactionid integer NOT NULL,
    productid integer NOT NULL,
    referenceorderid integer NOT NULL,
    referenceorderlineid integer DEFAULT 0 NOT NULL,
    transactiondate timestamp without time zone DEFAULT now() NOT NULL,
    transactiontype character(1) NOT NULL,
    quantity integer NOT NULL,
    actualcost numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_TransactionHistoryArchive_TransactionType" CHECK ((upper((transactiontype)::text) = ANY (ARRAY['W'::text, 'S'::text, 'P'::text])))
);


ALTER TABLE production.transactionhistoryarchive OWNER TO root;

--
-- Name: tha; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.tha AS
 SELECT transactionhistoryarchive.transactionid AS id,
    transactionhistoryarchive.transactionid,
    transactionhistoryarchive.productid,
    transactionhistoryarchive.referenceorderid,
    transactionhistoryarchive.referenceorderlineid,
    transactionhistoryarchive.transactiondate,
    transactionhistoryarchive.transactiontype,
    transactionhistoryarchive.quantity,
    transactionhistoryarchive.actualcost,
    transactionhistoryarchive.modifieddate
   FROM production.transactionhistoryarchive;


ALTER TABLE pr.tha OWNER TO root;

--
-- Name: unitmeasure; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.unitmeasure (
    unitmeasurecode character(3) NOT NULL,
    name varchar NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE production.unitmeasure OWNER TO root;

--
-- Name: um; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.um AS
 SELECT unitmeasure.unitmeasurecode AS id,
    unitmeasure.unitmeasurecode,
    unitmeasure.name,
    unitmeasure.modifieddate
   FROM production.unitmeasure;


ALTER TABLE pr.um OWNER TO root;

--
-- Name: workorder; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.workorder (
    workorderid integer NOT NULL,
    productid integer NOT NULL,
    orderqty integer NOT NULL,
    scrappedqty smallint NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone,
    duedate timestamp without time zone NOT NULL,
    scrapreasonid smallint,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_WorkOrder_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL))),
    CONSTRAINT "CK_WorkOrder_OrderQty" CHECK ((orderqty > 0)),
    CONSTRAINT "CK_WorkOrder_ScrappedQty" CHECK ((scrappedqty >= 0))
);


ALTER TABLE production.workorder OWNER TO root;

--
-- Name: w; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.w AS
 SELECT workorder.workorderid AS id,
    workorder.workorderid,
    workorder.productid,
    workorder.orderqty,
    workorder.scrappedqty,
    workorder.startdate,
    workorder.enddate,
    workorder.duedate,
    workorder.scrapreasonid,
    workorder.modifieddate
   FROM production.workorder;


ALTER TABLE pr.w OWNER TO root;

--
-- Name: workorderrouting; Type: TABLE; Schema: production; Owner: root
--

CREATE TABLE production.workorderrouting (
    workorderid integer NOT NULL,
    productid integer NOT NULL,
    operationsequence smallint NOT NULL,
    locationid smallint NOT NULL,
    scheduledstartdate timestamp without time zone NOT NULL,
    scheduledenddate timestamp without time zone NOT NULL,
    actualstartdate timestamp without time zone,
    actualenddate timestamp without time zone,
    actualresourcehrs numeric(9,4),
    plannedcost numeric NOT NULL,
    actualcost numeric,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_WorkOrderRouting_ActualCost" CHECK ((actualcost > 0.00)),
    CONSTRAINT "CK_WorkOrderRouting_ActualEndDate" CHECK (((actualenddate >= actualstartdate) OR (actualenddate IS NULL) OR (actualstartdate IS NULL))),
    CONSTRAINT "CK_WorkOrderRouting_ActualResourceHrs" CHECK ((actualresourcehrs >= 0.0000)),
    CONSTRAINT "CK_WorkOrderRouting_PlannedCost" CHECK ((plannedcost > 0.00)),
    CONSTRAINT "CK_WorkOrderRouting_ScheduledEndDate" CHECK ((scheduledenddate >= scheduledstartdate))
);


ALTER TABLE production.workorderrouting OWNER TO root;

--
-- Name: wr; Type: VIEW; Schema: pr; Owner: root
--

CREATE VIEW pr.wr AS
 SELECT workorderrouting.workorderid AS id,
    workorderrouting.workorderid,
    workorderrouting.productid,
    workorderrouting.operationsequence,
    workorderrouting.locationid,
    workorderrouting.scheduledstartdate,
    workorderrouting.scheduledenddate,
    workorderrouting.actualstartdate,
    workorderrouting.actualenddate,
    workorderrouting.actualresourcehrs,
    workorderrouting.plannedcost,
    workorderrouting.actualcost,
    workorderrouting.modifieddate
   FROM production.workorderrouting;


ALTER TABLE pr.wr OWNER TO root;

--
-- Name: billofmaterials_billofmaterialsid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.billofmaterials_billofmaterialsid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.billofmaterials_billofmaterialsid_seq OWNER TO root;

--
-- Name: billofmaterials_billofmaterialsid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.billofmaterials_billofmaterialsid_seq OWNED BY production.billofmaterials.billofmaterialsid;


--
-- Name: illustration_illustrationid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.illustration_illustrationid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.illustration_illustrationid_seq OWNER TO root;

--
-- Name: illustration_illustrationid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.illustration_illustrationid_seq OWNED BY production.illustration.illustrationid;


--
-- Name: location_locationid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.location_locationid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.location_locationid_seq OWNER TO root;

--
-- Name: location_locationid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.location_locationid_seq OWNED BY production.location.locationid;


--
-- Name: product_productid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.product_productid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.product_productid_seq OWNER TO root;

--
-- Name: product_productid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.product_productid_seq OWNED BY production.product.productid;


--
-- Name: productcategory_productcategoryid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.productcategory_productcategoryid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productcategory_productcategoryid_seq OWNER TO root;

--
-- Name: productcategory_productcategoryid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.productcategory_productcategoryid_seq OWNED BY production.productcategory.productcategoryid;


--
-- Name: productdescription_productdescriptionid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.productdescription_productdescriptionid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productdescription_productdescriptionid_seq OWNER TO root;

--
-- Name: productdescription_productdescriptionid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.productdescription_productdescriptionid_seq OWNED BY production.productdescription.productdescriptionid;


--
-- Name: productmodel_productmodelid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.productmodel_productmodelid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productmodel_productmodelid_seq OWNER TO root;

--
-- Name: productmodel_productmodelid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.productmodel_productmodelid_seq OWNED BY production.productmodel.productmodelid;


--
-- Name: productphoto_productphotoid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.productphoto_productphotoid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productphoto_productphotoid_seq OWNER TO root;

--
-- Name: productphoto_productphotoid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.productphoto_productphotoid_seq OWNED BY production.productphoto.productphotoid;


--
-- Name: productreview_productreviewid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.productreview_productreviewid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productreview_productreviewid_seq OWNER TO root;

--
-- Name: productreview_productreviewid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.productreview_productreviewid_seq OWNED BY production.productreview.productreviewid;


--
-- Name: productsubcategory_productsubcategoryid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.productsubcategory_productsubcategoryid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.productsubcategory_productsubcategoryid_seq OWNER TO root;

--
-- Name: productsubcategory_productsubcategoryid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.productsubcategory_productsubcategoryid_seq OWNED BY production.productsubcategory.productsubcategoryid;


--
-- Name: scrapreason_scrapreasonid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.scrapreason_scrapreasonid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.scrapreason_scrapreasonid_seq OWNER TO root;

--
-- Name: scrapreason_scrapreasonid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.scrapreason_scrapreasonid_seq OWNED BY production.scrapreason.scrapreasonid;


--
-- Name: transactionhistory_transactionid_seq; Type: SEQUENCE; Schema: production; Owner: root
--

CREATE SEQUENCE production.transactionhistory_transactionid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.transactionhistory_transactionid_seq OWNER TO root;

--
-- Name: transactionhistory_transactionid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.transactionhistory_transactionid_seq OWNED BY production.transactionhistory.transactionid;


--
-- Name: vproductanddescription; Type: MATERIALIZED VIEW; Schema: production; Owner: root
--

CREATE MATERIALIZED VIEW production.vproductanddescription AS
 SELECT p.productid,
    p.name,
    pm.name AS productmodel,
    pmx.cultureid,
    pd.description
   FROM (((production.product p
     JOIN production.productmodel pm ON ((p.productmodelid = pm.productmodelid)))
     JOIN production.productmodelproductdescriptionculture pmx ON ((pm.productmodelid = pmx.productmodelid)))
     JOIN production.productdescription pd ON ((pmx.productdescriptionid = pd.productdescriptionid)))
  ;


ALTER TABLE production.vproductanddescription OWNER TO root;

--
-- Name: vproductmodelcatalogdescription; Type: VIEW; Schema: production; Owner: root
--

 


ALTER TABLE production.vproductmodelcatalogdescription OWNER TO root;

--
-- Name: vproductmodelinstructions; Type: VIEW; Schema: production; Owner: root
--



CREATE SEQUENCE production.workorder_workorderid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production.workorder_workorderid_seq OWNER TO root;

--
-- Name: workorder_workorderid_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: root
--

ALTER SEQUENCE production.workorder_workorderid_seq OWNED BY production.workorder.workorderid;


--
-- Name: purchaseorderdetail; Type: TABLE; Schema: purchasing; Owner: root
--

CREATE TABLE purchasing.purchaseorderdetail (
    purchaseorderid integer NOT NULL,
    purchaseorderdetailid integer NOT NULL,
    duedate timestamp without time zone NOT NULL,
    orderqty smallint NOT NULL,
    productid integer NOT NULL,
    unitprice numeric NOT NULL,
    receivedqty numeric(8,2) NOT NULL,
    rejectedqty numeric(8,2) NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_PurchaseOrderDetail_OrderQty" CHECK ((orderqty > 0)),
    CONSTRAINT "CK_PurchaseOrderDetail_ReceivedQty" CHECK ((receivedqty >= 0.00)),
    CONSTRAINT "CK_PurchaseOrderDetail_RejectedQty" CHECK ((rejectedqty >= 0.00)),
    CONSTRAINT "CK_PurchaseOrderDetail_UnitPrice" CHECK ((unitprice >= 0.00))
);


ALTER TABLE purchasing.purchaseorderdetail OWNER TO root;

--
-- Name: pod; Type: VIEW; Schema: pu; Owner: root
--

CREATE VIEW pu.pod AS
 SELECT purchaseorderdetail.purchaseorderdetailid AS id,
    purchaseorderdetail.purchaseorderid,
    purchaseorderdetail.purchaseorderdetailid,
    purchaseorderdetail.duedate,
    purchaseorderdetail.orderqty,
    purchaseorderdetail.productid,
    purchaseorderdetail.unitprice,
    purchaseorderdetail.receivedqty,
    purchaseorderdetail.rejectedqty,
    purchaseorderdetail.modifieddate
   FROM purchasing.purchaseorderdetail;


ALTER TABLE pu.pod OWNER TO root;

--
-- Name: purchaseorderheader; Type: TABLE; Schema: purchasing; Owner: root
--

CREATE TABLE purchasing.purchaseorderheader (
    purchaseorderid integer NOT NULL,
    revisionnumber smallint DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    employeeid integer NOT NULL,
    vendorid integer NOT NULL,
    shipmethodid integer NOT NULL,
    orderdate timestamp without time zone DEFAULT now() NOT NULL,
    shipdate timestamp without time zone,
    subtotal numeric DEFAULT 0.00 NOT NULL,
    taxamt numeric DEFAULT 0.00 NOT NULL,
    freight numeric DEFAULT 0.00 NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_PurchaseOrderHeader_Freight" CHECK ((freight >= 0.00)),
    CONSTRAINT "CK_PurchaseOrderHeader_ShipDate" CHECK (((shipdate >= orderdate) OR (shipdate IS NULL))),
    CONSTRAINT "CK_PurchaseOrderHeader_Status" CHECK (((status >= 1) AND (status <= 4))),
    CONSTRAINT "CK_PurchaseOrderHeader_SubTotal" CHECK ((subtotal >= 0.00)),
    CONSTRAINT "CK_PurchaseOrderHeader_TaxAmt" CHECK ((taxamt >= 0.00))
);


ALTER TABLE purchasing.purchaseorderheader OWNER TO root;

--
-- Name: poh; Type: VIEW; Schema: pu; Owner: root
--

CREATE VIEW pu.poh AS
 SELECT purchaseorderheader.purchaseorderid AS id,
    purchaseorderheader.purchaseorderid,
    purchaseorderheader.revisionnumber,
    purchaseorderheader.status,
    purchaseorderheader.employeeid,
    purchaseorderheader.vendorid,
    purchaseorderheader.shipmethodid,
    purchaseorderheader.orderdate,
    purchaseorderheader.shipdate,
    purchaseorderheader.subtotal,
    purchaseorderheader.taxamt,
    purchaseorderheader.freight,
    purchaseorderheader.modifieddate
   FROM purchasing.purchaseorderheader;


ALTER TABLE pu.poh OWNER TO root;

--
-- Name: productvendor; Type: TABLE; Schema: purchasing; Owner: root
--

CREATE TABLE purchasing.productvendor (
    productid integer NOT NULL,
    businessentityid integer NOT NULL,
    averageleadtime integer NOT NULL,
    standardprice numeric NOT NULL,
    lastreceiptcost numeric,
    lastreceiptdate timestamp without time zone,
    minorderqty integer NOT NULL,
    maxorderqty integer NOT NULL,
    onorderqty integer,
    unitmeasurecode character(3) NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ProductVendor_AverageLeadTime" CHECK ((averageleadtime >= 1)),
    CONSTRAINT "CK_ProductVendor_LastReceiptCost" CHECK ((lastreceiptcost > 0.00)),
    CONSTRAINT "CK_ProductVendor_MaxOrderQty" CHECK ((maxorderqty >= 1)),
    CONSTRAINT "CK_ProductVendor_MinOrderQty" CHECK ((minorderqty >= 1)),
    CONSTRAINT "CK_ProductVendor_OnOrderQty" CHECK ((onorderqty >= 0)),
    CONSTRAINT "CK_ProductVendor_StandardPrice" CHECK ((standardprice > 0.00))
);


ALTER TABLE purchasing.productvendor OWNER TO root;

--
-- Name: pv; Type: VIEW; Schema: pu; Owner: root
--

CREATE VIEW pu.pv AS
 SELECT productvendor.productid AS id,
    productvendor.productid,
    productvendor.businessentityid,
    productvendor.averageleadtime,
    productvendor.standardprice,
    productvendor.lastreceiptcost,
    productvendor.lastreceiptdate,
    productvendor.minorderqty,
    productvendor.maxorderqty,
    productvendor.onorderqty,
    productvendor.unitmeasurecode,
    productvendor.modifieddate
   FROM purchasing.productvendor;


ALTER TABLE pu.pv OWNER TO root;

--
-- Name: shipmethod; Type: TABLE; Schema: purchasing; Owner: root
--

CREATE TABLE purchasing.shipmethod (
    shipmethodid integer NOT NULL,
    name varchar NOT NULL,
    shipbase numeric DEFAULT 0.00 NOT NULL,
    shiprate numeric DEFAULT 0.00 NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ShipMethod_ShipBase" CHECK ((shipbase > 0.00)),
    CONSTRAINT "CK_ShipMethod_ShipRate" CHECK ((shiprate > 0.00))
);


ALTER TABLE purchasing.shipmethod OWNER TO root;

--
-- Name: sm; Type: VIEW; Schema: pu; Owner: root
--

CREATE VIEW pu.sm AS
 SELECT shipmethod.shipmethodid AS id,
    shipmethod.shipmethodid,
    shipmethod.name,
    shipmethod.shipbase,
    shipmethod.shiprate,
    shipmethod.rowguid,
    shipmethod.modifieddate
   FROM purchasing.shipmethod;


ALTER TABLE pu.sm OWNER TO root;

--
-- Name: vendor; Type: TABLE; Schema: purchasing; Owner: root
--

CREATE TABLE purchasing.vendor (
    businessentityid integer NOT NULL,
    accountnumber VARCHAR NOT NULL,
    name varchar NOT NULL,
    creditrating smallint NOT NULL,
    preferredvendorstatus boolean DEFAULT true NOT NULL,
    activeflag boolean DEFAULT true NOT NULL,
    purchasingwebserviceurl character varying(1024),
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_Vendor_CreditRating" CHECK (((creditrating >= 1) AND (creditrating <= 5)))
);


ALTER TABLE purchasing.vendor OWNER TO root;

--
-- Name: v; Type: VIEW; Schema: pu; Owner: root
--

CREATE VIEW pu.v AS
 SELECT vendor.businessentityid AS id,
    vendor.businessentityid,
    vendor.accountnumber,
    vendor.name,
    vendor.creditrating,
    vendor.preferredvendorstatus,
    vendor.activeflag,
    vendor.purchasingwebserviceurl,
    vendor.modifieddate
   FROM purchasing.vendor;


ALTER TABLE pu.v OWNER TO root;

--
-- Name: purchaseorderdetail_purchaseorderdetailid_seq; Type: SEQUENCE; Schema: purchasing; Owner: root
--

CREATE SEQUENCE purchasing.purchaseorderdetail_purchaseorderdetailid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE purchasing.purchaseorderdetail_purchaseorderdetailid_seq OWNER TO root;

--
-- Name: purchaseorderdetail_purchaseorderdetailid_seq; Type: SEQUENCE OWNED BY; Schema: purchasing; Owner: root
--

ALTER SEQUENCE purchasing.purchaseorderdetail_purchaseorderdetailid_seq OWNED BY purchasing.purchaseorderdetail.purchaseorderdetailid;


--
-- Name: purchaseorderheader_purchaseorderid_seq; Type: SEQUENCE; Schema: purchasing; Owner: root
--

CREATE SEQUENCE purchasing.purchaseorderheader_purchaseorderid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE purchasing.purchaseorderheader_purchaseorderid_seq OWNER TO root;

--
-- Name: purchaseorderheader_purchaseorderid_seq; Type: SEQUENCE OWNED BY; Schema: purchasing; Owner: root
--

ALTER SEQUENCE purchasing.purchaseorderheader_purchaseorderid_seq OWNED BY purchasing.purchaseorderheader.purchaseorderid;


--
-- Name: shipmethod_shipmethodid_seq; Type: SEQUENCE; Schema: purchasing; Owner: root
--

CREATE SEQUENCE purchasing.shipmethod_shipmethodid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE purchasing.shipmethod_shipmethodid_seq OWNER TO root;

--
-- Name: shipmethod_shipmethodid_seq; Type: SEQUENCE OWNED BY; Schema: purchasing; Owner: root
--

ALTER SEQUENCE purchasing.shipmethod_shipmethodid_seq OWNED BY purchasing.shipmethod.shipmethodid;


--
-- Name: vvendorwithaddresses; Type: VIEW; Schema: purchasing; Owner: root
--

CREATE VIEW purchasing.vvendorwithaddresses AS
 SELECT v.businessentityid,
    v.name,
    at.name AS addresstype,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname
   FROM (((((purchasing.vendor v
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = v.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     JOIN person.addresstype at ON ((at.addresstypeid = bea.addresstypeid)));


ALTER TABLE purchasing.vvendorwithaddresses OWNER TO root;

--
-- Name: vvendorwithcontacts; Type: VIEW; Schema: purchasing; Owner: root
--

CREATE VIEW purchasing.vvendorwithcontacts AS
 SELECT v.businessentityid,
    v.name,
    ct.name AS contacttype,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion
   FROM ((((((purchasing.vendor v
     JOIN person.businessentitycontact bec ON ((bec.businessentityid = v.businessentityid)))
     JOIN person.contacttype ct ON ((ct.contacttypeid = bec.contacttypeid)))
     JOIN person.person p ON ((p.businessentityid = bec.personid)))
     LEFT JOIN person.emailaddress ea ON ((ea.businessentityid = p.businessentityid)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pnt.phonenumbertypeid = pp.phonenumbertypeid)));


ALTER TABLE purchasing.vvendorwithcontacts OWNER TO root;

--
-- Name: customer; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.customer (
    customerid integer NOT NULL,
    personid integer,
    storeid integer,
    territoryid integer,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.customer OWNER TO root;

--
-- Name: c; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.c AS
 SELECT customer.customerid AS id,
    customer.customerid,
    customer.personid,
    customer.storeid,
    customer.territoryid,
    customer.rowguid,
    customer.modifieddate
   FROM sales.customer;


ALTER TABLE sa.c OWNER TO root;

--
-- Name: creditcard; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.creditcard (
    creditcardid integer NOT NULL,
    cardtype character varying(50) NOT NULL,
    cardnumber character varying(25) NOT NULL,
    expmonth smallint NOT NULL,
    expyear smallint NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.creditcard OWNER TO root;

--
-- Name: cc; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.cc AS
 SELECT creditcard.creditcardid AS id,
    creditcard.creditcardid,
    creditcard.cardtype,
    creditcard.cardnumber,
    creditcard.expmonth,
    creditcard.expyear,
    creditcard.modifieddate
   FROM sales.creditcard;


ALTER TABLE sa.cc OWNER TO root;

--
-- Name: currencyrate; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.currencyrate (
    currencyrateid integer NOT NULL,
    currencyratedate timestamp without time zone NOT NULL,
    fromcurrencycode character(3) NOT NULL,
    tocurrencycode character(3) NOT NULL,
    averagerate numeric NOT NULL,
    endofdayrate numeric NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.currencyrate OWNER TO root;

--
-- Name: cr; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.cr AS
 SELECT currencyrate.currencyrateid,
    currencyrate.currencyratedate,
    currencyrate.fromcurrencycode,
    currencyrate.tocurrencycode,
    currencyrate.averagerate,
    currencyrate.endofdayrate,
    currencyrate.modifieddate
   FROM sales.currencyrate;


ALTER TABLE sa.cr OWNER TO root;

--
-- Name: countryregioncurrency; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.countryregioncurrency (
    countryregioncode character varying(3) NOT NULL,
    currencycode character(3) NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.countryregioncurrency OWNER TO root;

--
-- Name: crc; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.crc AS
 SELECT countryregioncurrency.countryregioncode,
    countryregioncurrency.currencycode,
    countryregioncurrency.modifieddate
   FROM sales.countryregioncurrency;


ALTER TABLE sa.crc OWNER TO root;

--
-- Name: currency; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.currency (
    currencycode character(3) NOT NULL,
    name varchar NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.currency OWNER TO root;

--
-- Name: cu; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.cu AS
 SELECT currency.currencycode AS id,
    currency.currencycode,
    currency.name,
    currency.modifieddate
   FROM sales.currency;


ALTER TABLE sa.cu OWNER TO root;

--
-- Name: personcreditcard; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.personcreditcard (
    businessentityid integer NOT NULL,
    creditcardid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.personcreditcard OWNER TO root;

--
-- Name: pcc; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.pcc AS
 SELECT personcreditcard.businessentityid AS id,
    personcreditcard.businessentityid,
    personcreditcard.creditcardid,
    personcreditcard.modifieddate
   FROM sales.personcreditcard;


ALTER TABLE sa.pcc OWNER TO root;

--
-- Name: store; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.store (
    businessentityid integer NOT NULL,
    name varchar NOT NULL,
    salespersonid integer,
    demographics VARCHAR,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.store OWNER TO root;

--
-- Name: s; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.s AS
 SELECT store.businessentityid AS id,
    store.businessentityid,
    store.name,
    store.salespersonid,
    store.demographics,
    store.rowguid,
    store.modifieddate
   FROM sales.store;


ALTER TABLE sa.s OWNER TO root;

--
-- Name: shoppingcartitem; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.shoppingcartitem (
    shoppingcartitemid integer NOT NULL,
    shoppingcartid character varying(50) NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    productid integer NOT NULL,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_ShoppingCartItem_Quantity" CHECK ((quantity >= 1))
);


ALTER TABLE sales.shoppingcartitem OWNER TO root;

--
-- Name: sci; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.sci AS
 SELECT shoppingcartitem.shoppingcartitemid AS id,
    shoppingcartitem.shoppingcartitemid,
    shoppingcartitem.shoppingcartid,
    shoppingcartitem.quantity,
    shoppingcartitem.productid,
    shoppingcartitem.datecreated,
    shoppingcartitem.modifieddate
   FROM sales.shoppingcartitem;


ALTER TABLE sa.sci OWNER TO root;

--
-- Name: specialoffer; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.specialoffer (
    specialofferid integer NOT NULL,
    description character varying(255) NOT NULL,
    discountpct numeric DEFAULT 0.00 NOT NULL,
    type character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone NOT NULL,
    minqty integer DEFAULT 0 NOT NULL,
    maxqty integer,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SpecialOffer_DiscountPct" CHECK ((discountpct >= 0.00)),
    CONSTRAINT "CK_SpecialOffer_EndDate" CHECK ((enddate >= startdate)),
    CONSTRAINT "CK_SpecialOffer_MaxQty" CHECK ((maxqty >= 0)),
    CONSTRAINT "CK_SpecialOffer_MinQty" CHECK ((minqty >= 0))
);


ALTER TABLE sales.specialoffer OWNER TO root;

--
-- Name: so; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.so AS
 SELECT specialoffer.specialofferid AS id,
    specialoffer.specialofferid,
    specialoffer.description,
    specialoffer.discountpct,
    specialoffer.type,
    specialoffer.category,
    specialoffer.startdate,
    specialoffer.enddate,
    specialoffer.minqty,
    specialoffer.maxqty,
    specialoffer.rowguid,
    specialoffer.modifieddate
   FROM sales.specialoffer;


ALTER TABLE sa.so OWNER TO root;

--
-- Name: salesorderdetail; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.salesorderdetail (
    salesorderid integer NOT NULL,
    salesorderdetailid integer NOT NULL,
    carriertrackingnumber character varying(25),
    orderqty smallint NOT NULL,
    productid integer NOT NULL,
    specialofferid integer NOT NULL,
    unitprice numeric NOT NULL,
    unitpricediscount numeric DEFAULT 0.0 NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesOrderDetail_OrderQty" CHECK ((orderqty > 0)),
    CONSTRAINT "CK_SalesOrderDetail_UnitPrice" CHECK ((unitprice >= 0.00)),
    CONSTRAINT "CK_SalesOrderDetail_UnitPriceDiscount" CHECK ((unitpricediscount >= 0.00))
);


ALTER TABLE sales.salesorderdetail OWNER TO root;

--
-- Name: sod; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.sod AS
 SELECT salesorderdetail.salesorderdetailid AS id,
    salesorderdetail.salesorderid,
    salesorderdetail.salesorderdetailid,
    salesorderdetail.carriertrackingnumber,
    salesorderdetail.orderqty,
    salesorderdetail.productid,
    salesorderdetail.specialofferid,
    salesorderdetail.unitprice,
    salesorderdetail.unitpricediscount,
    salesorderdetail.rowguid,
    salesorderdetail.modifieddate
   FROM sales.salesorderdetail;


ALTER TABLE sa.sod OWNER TO root;

--
-- Name: salesorderheader; Type: TABLE; Schema: sales; Owner: root
--
DROP TABLE sales.salesorderheader ;
CREATE TABLE sales.salesorderheader (
    salesorderid integer NOT NULL,
    revisionnumber smallint DEFAULT 0 NOT NULL,
    orderdate timestamp without time zone DEFAULT now() NOT NULL,
    duedate timestamp without time zone NOT NULL,
    shipdate timestamp without time zone,
    status smallint DEFAULT 1 NOT NULL,
    onlineorderflag boolean DEFAULT true NOT NULL,
    purchaseordernumber VARCHAR,
    accountnumber VARCHAR,
    customerid integer NOT NULL,
    salespersonid integer,
    territoryid integer,
    billtoaddressid integer NOT NULL,
    shiptoaddressid integer NOT NULL,
    shipmethodid integer NOT NULL,
    creditcardid integer,
    creditcardapprovalcode character varying(15),
    currencyrateid integer,
    subtotal numeric DEFAULT 0.00 NOT NULL,
    taxamt numeric DEFAULT 0.00 NOT NULL,
    freight numeric DEFAULT 0.00 NOT NULL,
    totaldue numeric,
    comment character varying(128),
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesOrderHeader_DueDate" CHECK ((duedate >= orderdate)),
    CONSTRAINT "CK_SalesOrderHeader_Freight" CHECK ((freight >= 0.00)),
    CONSTRAINT "CK_SalesOrderHeader_ShipDate" CHECK (((shipdate >= orderdate) OR (shipdate IS NULL))),
    CONSTRAINT "CK_SalesOrderHeader_Status" CHECK (((status >= 0) AND (status <= 8))),
    CONSTRAINT "CK_SalesOrderHeader_SubTotal" CHECK ((subtotal >= 0.00)),
    CONSTRAINT "CK_SalesOrderHeader_TaxAmt" CHECK ((taxamt >= 0.00))
);


ALTER TABLE sales.salesorderheader OWNER TO root;

--
-- Name: soh; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.soh AS
 SELECT salesorderheader.salesorderid AS id,
    salesorderheader.salesorderid,
    salesorderheader.revisionnumber,
    salesorderheader.orderdate,
    salesorderheader.duedate,
    salesorderheader.shipdate,
    salesorderheader.status,
    salesorderheader.onlineorderflag,
    salesorderheader.purchaseordernumber,
    salesorderheader.accountnumber,
    salesorderheader.customerid,
    salesorderheader.salespersonid,
    salesorderheader.territoryid,
    salesorderheader.billtoaddressid,
    salesorderheader.shiptoaddressid,
    salesorderheader.shipmethodid,
    salesorderheader.creditcardid,
    salesorderheader.creditcardapprovalcode,
    salesorderheader.currencyrateid,
    salesorderheader.subtotal,
    salesorderheader.taxamt,
    salesorderheader.freight,
    salesorderheader.totaldue,
    salesorderheader.comment,
    salesorderheader.rowguid,
    salesorderheader.modifieddate
   FROM sales.salesorderheader;


ALTER TABLE sa.soh OWNER TO root;

--
-- Name: salesorderheadersalesreason; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.salesorderheadersalesreason (
    salesorderid integer NOT NULL,
    salesreasonid integer NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.salesorderheadersalesreason OWNER TO root;

--
-- Name: sohsr; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.sohsr AS
 SELECT salesorderheadersalesreason.salesorderid,
    salesorderheadersalesreason.salesreasonid,
    salesorderheadersalesreason.modifieddate
   FROM sales.salesorderheadersalesreason;


ALTER TABLE sa.sohsr OWNER TO root;

--
-- Name: specialofferproduct; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.specialofferproduct (
    specialofferid integer NOT NULL,
    productid integer NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.specialofferproduct OWNER TO root;

--
-- Name: sop; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.sop AS
 SELECT specialofferproduct.specialofferid AS id,
    specialofferproduct.specialofferid,
    specialofferproduct.productid,
    specialofferproduct.rowguid,
    specialofferproduct.modifieddate
   FROM sales.specialofferproduct;


ALTER TABLE sa.sop OWNER TO root;

--
-- Name: salesperson; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.salesperson (
    businessentityid integer NOT NULL,
    territoryid integer,
    salesquota numeric,
    bonus numeric DEFAULT 0.00 NOT NULL,
    commissionpct numeric DEFAULT 0.00 NOT NULL,
    salesytd numeric DEFAULT 0.00 NOT NULL,
    saleslastyear numeric DEFAULT 0.00 NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesPerson_Bonus" CHECK ((bonus >= 0.00)),
    CONSTRAINT "CK_SalesPerson_CommissionPct" CHECK ((commissionpct >= 0.00)),
    CONSTRAINT "CK_SalesPerson_SalesLastYear" CHECK ((saleslastyear >= 0.00)),
    CONSTRAINT "CK_SalesPerson_SalesQuota" CHECK ((salesquota > 0.00)),
    CONSTRAINT "CK_SalesPerson_SalesYTD" CHECK ((salesytd >= 0.00))
);


ALTER TABLE sales.salesperson OWNER TO root;

--
-- Name: sp; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.sp AS
 SELECT salesperson.businessentityid AS id,
    salesperson.businessentityid,
    salesperson.territoryid,
    salesperson.salesquota,
    salesperson.bonus,
    salesperson.commissionpct,
    salesperson.salesytd,
    salesperson.saleslastyear,
    salesperson.rowguid,
    salesperson.modifieddate
   FROM sales.salesperson;


ALTER TABLE sa.sp OWNER TO root;

--
-- Name: salespersonquotahistory; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.salespersonquotahistory (
    businessentityid integer NOT NULL,
    quotadate timestamp without time zone NOT NULL,
    salesquota numeric NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesPersonQuotaHistory_SalesQuota" CHECK ((salesquota > 0.00))
);


ALTER TABLE sales.salespersonquotahistory OWNER TO root;

--
-- Name: spqh; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.spqh AS
 SELECT salespersonquotahistory.businessentityid AS id,
    salespersonquotahistory.businessentityid,
    salespersonquotahistory.quotadate,
    salespersonquotahistory.salesquota,
    salespersonquotahistory.rowguid,
    salespersonquotahistory.modifieddate
   FROM sales.salespersonquotahistory;


ALTER TABLE sa.spqh OWNER TO root;

--
-- Name: salesreason; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.salesreason (
    salesreasonid integer NOT NULL,
    name varchar NOT NULL,
    reasontype varchar NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE sales.salesreason OWNER TO root;

--
-- Name: sr; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.sr AS
 SELECT salesreason.salesreasonid AS id,
    salesreason.salesreasonid,
    salesreason.name,
    salesreason.reasontype,
    salesreason.modifieddate
   FROM sales.salesreason;


ALTER TABLE sa.sr OWNER TO root;

--
-- Name: salesterritory; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.salesterritory (
    territoryid integer NOT NULL,
    name varchar NOT NULL,
    countryregioncode character varying(3) NOT NULL,
    "group" character varying(50) NOT NULL,
    salesytd numeric DEFAULT 0.00 NOT NULL,
    saleslastyear numeric DEFAULT 0.00 NOT NULL,
    costytd numeric DEFAULT 0.00 NOT NULL,
    costlastyear numeric DEFAULT 0.00 NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesTerritory_CostLastYear" CHECK ((costlastyear >= 0.00)),
    CONSTRAINT "CK_SalesTerritory_CostYTD" CHECK ((costytd >= 0.00)),
    CONSTRAINT "CK_SalesTerritory_SalesLastYear" CHECK ((saleslastyear >= 0.00)),
    CONSTRAINT "CK_SalesTerritory_SalesYTD" CHECK ((salesytd >= 0.00))
);


ALTER TABLE sales.salesterritory OWNER TO root;

--
-- Name: st; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.st AS
 SELECT salesterritory.territoryid AS id,
    salesterritory.territoryid,
    salesterritory.name,
    salesterritory.countryregioncode,
    salesterritory."group",
    salesterritory.salesytd,
    salesterritory.saleslastyear,
    salesterritory.costytd,
    salesterritory.costlastyear,
    salesterritory.rowguid,
    salesterritory.modifieddate
   FROM sales.salesterritory;


ALTER TABLE sa.st OWNER TO root;

--
-- Name: salesterritoryhistory; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.salesterritoryhistory (
    businessentityid integer NOT NULL,
    territoryid integer NOT NULL,
    startdate timestamp without time zone NOT NULL,
    enddate timestamp without time zone,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesTerritoryHistory_EndDate" CHECK (((enddate >= startdate) OR (enddate IS NULL)))
);


ALTER TABLE sales.salesterritoryhistory OWNER TO root;

--
-- Name: sth; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.sth AS
 SELECT salesterritoryhistory.territoryid AS id,
    salesterritoryhistory.businessentityid,
    salesterritoryhistory.territoryid,
    salesterritoryhistory.startdate,
    salesterritoryhistory.enddate,
    salesterritoryhistory.rowguid,
    salesterritoryhistory.modifieddate
   FROM sales.salesterritoryhistory;


ALTER TABLE sa.sth OWNER TO root;

--
-- Name: salestaxrate; Type: TABLE; Schema: sales; Owner: root
--

CREATE TABLE sales.salestaxrate (
    salestaxrateid integer NOT NULL,
    stateprovinceid integer NOT NULL,
    taxtype smallint NOT NULL,
    taxrate numeric DEFAULT 0.00 NOT NULL,
    name varchar NOT NULL,
    rowguid uuid DEFAULT gen_random_uuid() NOT NULL,
    modifieddate timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CK_SalesTaxRate_TaxType" CHECK (((taxtype >= 1) AND (taxtype <= 3)))
);


ALTER TABLE sales.salestaxrate OWNER TO root;

--
-- Name: tr; Type: VIEW; Schema: sa; Owner: root
--

CREATE VIEW sa.tr AS
 SELECT salestaxrate.salestaxrateid AS id,
    salestaxrate.salestaxrateid,
    salestaxrate.stateprovinceid,
    salestaxrate.taxtype,
    salestaxrate.taxrate,
    salestaxrate.name,
    salestaxrate.rowguid,
    salestaxrate.modifieddate
   FROM sales.salestaxrate;


ALTER TABLE sa.tr OWNER TO root;

--
-- Name: creditcard_creditcardid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.creditcard_creditcardid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.creditcard_creditcardid_seq OWNER TO root;

--
-- Name: creditcard_creditcardid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.creditcard_creditcardid_seq OWNED BY sales.creditcard.creditcardid;


--
-- Name: currencyrate_currencyrateid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.currencyrate_currencyrateid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.currencyrate_currencyrateid_seq OWNER TO root;

--
-- Name: currencyrate_currencyrateid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.currencyrate_currencyrateid_seq OWNED BY sales.currencyrate.currencyrateid;


--
-- Name: customer_customerid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.customer_customerid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.customer_customerid_seq OWNER TO root;

--
-- Name: customer_customerid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.customer_customerid_seq OWNED BY sales.customer.customerid;


--
-- Name: salesorderdetail_salesorderdetailid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.salesorderdetail_salesorderdetailid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salesorderdetail_salesorderdetailid_seq OWNER TO root;

--
-- Name: salesorderdetail_salesorderdetailid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.salesorderdetail_salesorderdetailid_seq OWNED BY sales.salesorderdetail.salesorderdetailid;


--
-- Name: salesorderheader_salesorderid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.salesorderheader_salesorderid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salesorderheader_salesorderid_seq OWNER TO root;

--
-- Name: salesorderheader_salesorderid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.salesorderheader_salesorderid_seq OWNED BY sales.salesorderheader.salesorderid;


--
-- Name: salesreason_salesreasonid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.salesreason_salesreasonid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salesreason_salesreasonid_seq OWNER TO root;

--
-- Name: salesreason_salesreasonid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.salesreason_salesreasonid_seq OWNED BY sales.salesreason.salesreasonid;


--
-- Name: salestaxrate_salestaxrateid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.salestaxrate_salestaxrateid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salestaxrate_salestaxrateid_seq OWNER TO root;

--
-- Name: salestaxrate_salestaxrateid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.salestaxrate_salestaxrateid_seq OWNED BY sales.salestaxrate.salestaxrateid;


--
-- Name: salesterritory_territoryid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.salesterritory_territoryid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.salesterritory_territoryid_seq OWNER TO root;

--
-- Name: salesterritory_territoryid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.salesterritory_territoryid_seq OWNED BY sales.salesterritory.territoryid;


--
-- Name: shoppingcartitem_shoppingcartitemid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.shoppingcartitem_shoppingcartitemid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.shoppingcartitem_shoppingcartitemid_seq OWNER TO root;

--
-- Name: shoppingcartitem_shoppingcartitemid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.shoppingcartitem_shoppingcartitemid_seq OWNED BY sales.shoppingcartitem.shoppingcartitemid;


--
-- Name: specialoffer_specialofferid_seq; Type: SEQUENCE; Schema: sales; Owner: root
--

CREATE SEQUENCE sales.specialoffer_specialofferid_seq
    /* AS integer */
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales.specialoffer_specialofferid_seq OWNER TO root;

--
-- Name: specialoffer_specialofferid_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: root
--

ALTER SEQUENCE sales.specialoffer_specialofferid_seq OWNED BY sales.specialoffer.specialofferid;


--
-- Name: vindividualcustomer; Type: VIEW; Schema: sales; Owner: root
--

CREATE VIEW sales.vindividualcustomer AS
 SELECT p.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion,
    at.name AS addresstype,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname,
    p.demographics
   FROM (((((((((person.person p
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = p.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     JOIN person.addresstype at ON ((at.addresstypeid = bea.addresstypeid)))
     JOIN sales.customer c ON ((c.personid = p.businessentityid)))
     LEFT JOIN person.emailaddress ea ON ((ea.businessentityid = p.businessentityid)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pnt.phonenumbertypeid = pp.phonenumbertypeid)))
  WHERE (c.storeid IS NULL);


ALTER TABLE sales.vindividualcustomer OWNER TO root;

--
-- Name: vpersondemographics; Type: VIEW; Schema: sales; Owner: root
--

 


ALTER TABLE sales.vpersondemographics OWNER TO root;

--
-- Name: vsalesperson; Type: VIEW; Schema: sales; Owner: root
--

CREATE VIEW sales.vsalesperson AS
 SELECT s.businessentityid,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    e.jobtitle,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname,
    st.name AS territoryname,
    st."group" AS territorygroup,
    s.salesquota,
    s.salesytd,
    s.saleslastyear
   FROM ((((((((((sales.salesperson s
     JOIN humanresources.employee e ON ((e.businessentityid = s.businessentityid)))
     JOIN person.person p ON ((p.businessentityid = s.businessentityid)))
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = s.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     LEFT JOIN sales.salesterritory st ON ((st.territoryid = s.territoryid)))
     LEFT JOIN person.emailaddress ea ON ((ea.businessentityid = p.businessentityid)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pnt.phonenumbertypeid = pp.phonenumbertypeid)));


ALTER TABLE sales.vsalesperson OWNER TO root;

--
-- Name: vsalespersonsalesbyfiscalyears; Type: VIEW; Schema: sales; Owner: root
--

CREATE VIEW sales.vsalespersonsalesbyfiscalyears AS
 SELECT salestotal."SalesPersonID",
    salestotal."FullName",
    salestotal."JobTitle",
    salestotal."SalesTerritory",
    salestotal."2012",
    salestotal."2013",
    salestotal."2014"
   FROM public.crosstab('SELECT
    SalesPersonID
    ,FullName
    ,JobTitle
    ,SalesTerritory
    ,FiscalYear
    ,SalesTotal
FROM Sales.vSalesPersonSalesByFiscalYearsData
ORDER BY 2,4'::text, 'SELECT unnest(''{2012,2013,2014}''::text[])'::text) salestotal("SalesPersonID" integer, "FullName" text, "JobTitle" text, "SalesTerritory" text, "2012" numeric(12,4), "2013" numeric(12,4), "2014" numeric(12,4));


ALTER TABLE sales.vsalespersonsalesbyfiscalyears OWNER TO root;

--
-- Name: vsalespersonsalesbyfiscalyearsdata; Type: VIEW; Schema: sales; Owner: root
--

CREATE VIEW sales.vsalespersonsalesbyfiscalyearsdata AS
 SELECT granular.salespersonid,
    granular.fullname,
    granular.jobtitle,
    granular.salesterritory,
    sum(granular.subtotal) AS salestotal,
    granular.fiscalyear
   FROM ( SELECT soh.salespersonid,
            ((((p.firstname)::text || ' '::text) || COALESCE(((p.middlename)::text || ' '::text), ''::text)) || (p.lastname)::text) AS fullname,
            e.jobtitle,
            st.name AS salesterritory,
            soh.subtotal,
            date_part('year'::text, (soh.orderdate + '6 mons'::interval)) AS fiscalyear
           FROM ((((sales.salesperson sp
             JOIN sales.salesorderheader soh ON ((sp.businessentityid = soh.salespersonid)))
             JOIN sales.salesterritory st ON ((sp.territoryid = st.territoryid)))
             JOIN humanresources.employee e ON ((soh.salespersonid = e.businessentityid)))
             JOIN person.person p ON ((p.businessentityid = sp.businessentityid)))) granular
  GROUP BY granular.salespersonid, granular.fullname, granular.jobtitle, granular.salesterritory, granular.fiscalyear;


ALTER TABLE sales.vsalespersonsalesbyfiscalyearsdata OWNER TO root;

--
-- Name: vstorewithaddresses; Type: VIEW; Schema: sales; Owner: root
--

CREATE VIEW sales.vstorewithaddresses AS
 SELECT s.businessentityid,
    s.name,
    at.name AS addresstype,
    a.addressline1,
    a.addressline2,
    a.city,
    sp.name AS stateprovincename,
    a.postalcode,
    cr.name AS countryregionname
   FROM (((((sales.store s
     JOIN person.businessentityaddress bea ON ((bea.businessentityid = s.businessentityid)))
     JOIN person.address a ON ((a.addressid = bea.addressid)))
     JOIN person.stateprovince sp ON ((sp.stateprovinceid = a.stateprovinceid)))
     JOIN person.countryregion cr ON (((cr.countryregioncode)::text = (sp.countryregioncode)::text)))
     JOIN person.addresstype at ON ((at.addresstypeid = bea.addresstypeid)));


ALTER TABLE sales.vstorewithaddresses OWNER TO root;

--
-- Name: vstorewithcontacts; Type: VIEW; Schema: sales; Owner: root
--

CREATE VIEW sales.vstorewithcontacts AS
 SELECT s.businessentityid,
    s.name,
    ct.name AS contacttype,
    p.title,
    p.firstname,
    p.middlename,
    p.lastname,
    p.suffix,
    pp.phonenumber,
    pnt.name AS phonenumbertype,
    ea.emailaddress,
    p.emailpromotion
   FROM ((((((sales.store s
     JOIN person.businessentitycontact bec ON ((bec.businessentityid = s.businessentityid)))
     JOIN person.contacttype ct ON ((ct.contacttypeid = bec.contacttypeid)))
     JOIN person.person p ON ((p.businessentityid = bec.personid)))
     LEFT JOIN person.emailaddress ea ON ((ea.businessentityid = p.businessentityid)))
     LEFT JOIN person.personphone pp ON ((pp.businessentityid = p.businessentityid)))
     LEFT JOIN person.phonenumbertype pnt ON ((pnt.phonenumbertypeid = pp.phonenumbertypeid)));


ALTER TABLE sales.vstorewithcontacts OWNER TO root;

--
-- Name: vstorewithdemographics; Type: VIEW; Schema: sales; Owner: root
--

 


ALTER TABLE sales.vstorewithdemographics OWNER TO root;

--
-- Name: department departmentid; Type: DEFAULT; Schema: humanresources; Owner: root
--

ALTER TABLE ONLY humanresources.department ALTER COLUMN departmentid SET DEFAULT nextval('humanresources.department_departmentid_seq'::regclass);


--
-- Name: jobcandidate jobcandidateid; Type: DEFAULT; Schema: humanresources; Owner: root
--

ALTER TABLE ONLY humanresources.jobcandidate ALTER COLUMN jobcandidateid SET DEFAULT nextval('humanresources.jobcandidate_jobcandidateid_seq'::regclass);


--
-- Name: shift shiftid; Type: DEFAULT; Schema: humanresources; Owner: root
--

ALTER TABLE ONLY humanresources.shift ALTER COLUMN shiftid SET DEFAULT nextval('humanresources.shift_shiftid_seq'::regclass);


--
-- Name: address addressid; Type: DEFAULT; Schema: person; Owner: root
--

ALTER TABLE ONLY person.address ALTER COLUMN addressid SET DEFAULT nextval('person.address_addressid_seq'::regclass);


--
-- Name: addresstype addresstypeid; Type: DEFAULT; Schema: person; Owner: root
--

ALTER TABLE ONLY person.addresstype ALTER COLUMN addresstypeid SET DEFAULT nextval('person.addresstype_addresstypeid_seq'::regclass);


--
-- Name: businessentity businessentityid; Type: DEFAULT; Schema: person; Owner: root
--

ALTER TABLE ONLY person.businessentity ALTER COLUMN businessentityid SET DEFAULT nextval('person.businessentity_businessentityid_seq'::regclass);


--
-- Name: contacttype contacttypeid; Type: DEFAULT; Schema: person; Owner: root
--

ALTER TABLE ONLY person.contacttype ALTER COLUMN contacttypeid SET DEFAULT nextval('person.contacttype_contacttypeid_seq'::regclass);


--
-- Name: emailaddress emailaddressid; Type: DEFAULT; Schema: person; Owner: root
--

ALTER TABLE ONLY person.emailaddress ALTER COLUMN emailaddressid SET DEFAULT nextval('person.emailaddress_emailaddressid_seq'::regclass);


--
-- Name: phonenumbertype phonenumbertypeid; Type: DEFAULT; Schema: person; Owner: root
--

ALTER TABLE ONLY person.phonenumbertype ALTER COLUMN phonenumbertypeid SET DEFAULT nextval('person.phonenumbertype_phonenumbertypeid_seq'::regclass);


--
-- Name: stateprovince stateprovinceid; Type: DEFAULT; Schema: person; Owner: root
--

ALTER TABLE ONLY person.stateprovince ALTER COLUMN stateprovinceid SET DEFAULT nextval('person.stateprovince_stateprovinceid_seq'::regclass);


--
-- Name: billofmaterials billofmaterialsid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.billofmaterials ALTER COLUMN billofmaterialsid SET DEFAULT nextval('production.billofmaterials_billofmaterialsid_seq'::regclass);


--
-- Name: illustration illustrationid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.illustration ALTER COLUMN illustrationid SET DEFAULT nextval('production.illustration_illustrationid_seq'::regclass);


--
-- Name: location locationid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.location ALTER COLUMN locationid SET DEFAULT nextval('production.location_locationid_seq'::regclass);


--
-- Name: product productid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.product ALTER COLUMN productid SET DEFAULT nextval('production.product_productid_seq'::regclass);


--
-- Name: productcategory productcategoryid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.productcategory ALTER COLUMN productcategoryid SET DEFAULT nextval('production.productcategory_productcategoryid_seq'::regclass);


--
-- Name: productdescription productdescriptionid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.productdescription ALTER COLUMN productdescriptionid SET DEFAULT nextval('production.productdescription_productdescriptionid_seq'::regclass);


--
-- Name: productmodel productmodelid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.productmodel ALTER COLUMN productmodelid SET DEFAULT nextval('production.productmodel_productmodelid_seq'::regclass);


--
-- Name: productphoto productphotoid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.productphoto ALTER COLUMN productphotoid SET DEFAULT nextval('production.productphoto_productphotoid_seq'::regclass);


--
-- Name: productreview productreviewid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.productreview ALTER COLUMN productreviewid SET DEFAULT nextval('production.productreview_productreviewid_seq'::regclass);


--
-- Name: productsubcategory productsubcategoryid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.productsubcategory ALTER COLUMN productsubcategoryid SET DEFAULT nextval('production.productsubcategory_productsubcategoryid_seq'::regclass);


--
-- Name: scrapreason scrapreasonid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.scrapreason ALTER COLUMN scrapreasonid SET DEFAULT nextval('production.scrapreason_scrapreasonid_seq'::regclass);


--
-- Name: transactionhistory transactionid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.transactionhistory ALTER COLUMN transactionid SET DEFAULT nextval('production.transactionhistory_transactionid_seq'::regclass);


--
-- Name: workorder workorderid; Type: DEFAULT; Schema: production; Owner: root
--

ALTER TABLE ONLY production.workorder ALTER COLUMN workorderid SET DEFAULT nextval('production.workorder_workorderid_seq'::regclass);


--
-- Name: purchaseorderdetail purchaseorderdetailid; Type: DEFAULT; Schema: purchasing; Owner: root
--

ALTER TABLE ONLY purchasing.purchaseorderdetail ALTER COLUMN purchaseorderdetailid SET DEFAULT nextval('purchasing.purchaseorderdetail_purchaseorderdetailid_seq'::regclass);


--
-- Name: purchaseorderheader purchaseorderid; Type: DEFAULT; Schema: purchasing; Owner: root
--

ALTER TABLE ONLY purchasing.purchaseorderheader ALTER COLUMN purchaseorderid SET DEFAULT nextval('purchasing.purchaseorderheader_purchaseorderid_seq'::regclass);


--
-- Name: shipmethod shipmethodid; Type: DEFAULT; Schema: purchasing; Owner: root
--

ALTER TABLE ONLY purchasing.shipmethod ALTER COLUMN shipmethodid SET DEFAULT nextval('purchasing.shipmethod_shipmethodid_seq'::regclass);


--
-- Name: creditcard creditcardid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.creditcard ALTER COLUMN creditcardid SET DEFAULT nextval('sales.creditcard_creditcardid_seq'::regclass);


--
-- Name: currencyrate currencyrateid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.currencyrate ALTER COLUMN currencyrateid SET DEFAULT nextval('sales.currencyrate_currencyrateid_seq'::regclass);


--
-- Name: customer customerid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.customer ALTER COLUMN customerid SET DEFAULT nextval('sales.customer_customerid_seq'::regclass);


--
-- Name: salesorderdetail salesorderdetailid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.salesorderdetail ALTER COLUMN salesorderdetailid SET DEFAULT nextval('sales.salesorderdetail_salesorderdetailid_seq'::regclass);


--
-- Name: salesorderheader salesorderid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.salesorderheader ALTER COLUMN salesorderid SET DEFAULT nextval('sales.salesorderheader_salesorderid_seq'::regclass);


--
-- Name: salesreason salesreasonid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.salesreason ALTER COLUMN salesreasonid SET DEFAULT nextval('sales.salesreason_salesreasonid_seq'::regclass);


--
-- Name: salestaxrate salestaxrateid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.salestaxrate ALTER COLUMN salestaxrateid SET DEFAULT nextval('sales.salestaxrate_salestaxrateid_seq'::regclass);


--
-- Name: salesterritory territoryid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.salesterritory ALTER COLUMN territoryid SET DEFAULT nextval('sales.salesterritory_territoryid_seq'::regclass);


--
-- Name: shoppingcartitem shoppingcartitemid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.shoppingcartitem ALTER COLUMN shoppingcartitemid SET DEFAULT nextval('sales.shoppingcartitem_shoppingcartitemid_seq'::regclass);


--
-- Name: specialoffer specialofferid; Type: DEFAULT; Schema: sales; Owner: root
--

ALTER TABLE ONLY sales.specialoffer ALTER COLUMN specialofferid SET DEFAULT nextval('sales.specialoffer_specialofferid_seq'::regclass);