\set ON_ERROR_STOP true
\connect dcsa_openapi

BEGIN;

SELECT 'Start: 08_03_test_data_ovs.sql...' as progress;

INSERT INTO dcsa_im_v3_0.address (
    id,
    name,
    street,
    street_number,
    floor,
    postal_code,
    city,
    state_region,
    country
) VALUES (
    uuid('8791f557-fe69-42c9-a420-f39f09dd6207'),
    'Henrik',
    'Kronprincessegade',
    '54',
    '5. sal',
    '1306',
    'København',
    'N/A',
    'Denmark'
);

INSERT INTO  dcsa_im_v3_0.party (
    id,
    party_name,
    tax_reference_1,
    tax_reference_2,
    public_key,
    address_id
) VALUES ( 
    'be5bc290-7bac-48bb-a211-f3fa5a3ab3ae',
    'Asseco Denmark',
    'CVR-25645774',
    'CVR-25645774',
    'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkFzaW',
    uuid('8791f557-fe69-42c9-a420-f39f09dd6207')
);

INSERT INTO  dcsa_im_v3_0.party_identifying_code (
    dcsa_responsible_agency_code,
    party_id,
    party_code,
    code_list_name
) VALUES (
    'SCAC',
    'be5bc290-7bac-48bb-a211-f3fa5a3ab3ae',
    'MMCU',
    'LCL'
);

INSERT INTO dcsa_im_v3_0.vessel (
    vessel_imo_number,
    vessel_name,
    vessel_flag,
    vessel_call_sign,
    vessel_operator_carrier_id
) VALUES (
    '9811000',
    'Ever Given',
    'PA',
    'H3RC',
    (SELECT id FROM dcsa_im_v3_0.carrier WHERE smdg_code = 'EMC')
);

INSERT INTO dcsa_im_v3_0.service (
    id,
    carrier_id,
    carrier_service_code,
    carrier_service_name
) VALUES (
     '03482296-ef9c-11eb-9a03-0242ac131999',
     (SELECT id FROM dcsa_im_v3_0.carrier WHERE smdg_code = 'MSK'),
     'A_CSC',
     'A_carrier_service_name'
);


INSERT INTO dcsa_im_v3_0.voyage (
    id,
    carrier_voyage_number,
    service_id
) VALUES (
     '03482296-ef9c-11eb-9a03-0242ac131233',
     'A_carrier_voyage_number',
     '03482296-ef9c-11eb-9a03-0242ac131999'
);

INSERT INTO dcsa_im_v3_0.location (
    id,
    location_name,
    address_id,
    latitude,
    longitude,
    un_location_code
) VALUES (
    '06aca2f6-f1d0-48f8-ba46-9a3480adfd23',
    'Eiffel Tower',
    uuid('8791f557-fe69-42c9-a420-f39f09dd6207'),
    '48.8585500',
    '2.294492036',
    'USNYC'
), (
    '6748a259-fb7e-4f27-9a88-3669e8b9c5f8',
    'Eiffel Tower 2',
    uuid('8791f557-fe69-42c9-a420-f39f09dd6207'),
    '48.8585500',
    '2.294492036',
    'SGSIN'
);

INSERT INTO dcsa_im_v3_0.transport_call (
    id,
    transport_call_reference,
    transport_call_sequence_number,
    facility_id,
    facility_type_code,
    mode_of_transport_code,
    vessel_id,
    import_voyage_id,
    export_voyage_id,
    location_id
) VALUES (
    '7f2d833c-2c7f-4fc5-a71a-e510881da64a'::uuid,
    'TC-REF-08_03-A',
    1,
    (SELECT id FROM dcsa_im_v3_0.facility WHERE un_location_code = 'USNYC' AND facility_smdg_code = 'APMT'),
    'POTE',
    (SELECT mode_of_transport_code FROM dcsa_im_v3_0.mode_of_transport WHERE dcsa_transport_type = 'VESSEL'),
    (SELECT id FROM dcsa_im_v3_0.vessel WHERE vessel_imo_number = '9811000'),
    uuid('03482296-ef9c-11eb-9a03-0242ac131233'),
    uuid('03482296-ef9c-11eb-9a03-0242ac131233'),
    uuid('06aca2f6-f1d0-48f8-ba46-9a3480adfd23')
), (
    'b785317a-2340-4db7-8fb3-c8dfb1edfa60'::uuid,
    'TC-REF-08_03-B',
    2,
    (SELECT id FROM dcsa_im_v3_0.facility WHERE un_location_code = 'SGSIN' AND facility_smdg_code = 'PSABT'),
    'POTE',
    (SELECT mode_of_transport_code FROM dcsa_im_v3_0.mode_of_transport WHERE dcsa_transport_type = 'VESSEL'),
    (SELECT id FROM dcsa_im_v3_0.vessel WHERE vessel_imo_number = '9811000'),
    (SELECT id FROM dcsa_im_v3_0.voyage WHERE carrier_voyage_number = 'TNT1E'),
    (SELECT id FROM dcsa_im_v3_0.voyage WHERE carrier_voyage_number = 'TNT1E'),
    uuid('6748a259-fb7e-4f27-9a88-3669e8b9c5f8')
);

INSERT INTO dcsa_im_v3_0.transport (
    transport_reference,
    transport_name,
    load_transport_call_id,
    discharge_transport_call_id
) VALUES (
    'transport reference',
    'Transport name (Singapore -> NYC)',
    '7f2d833c-2c7f-4fc5-a71a-e510881da64a'::uuid,
    'b785317a-2340-4db7-8fb3-c8dfb1edfa60'::uuid
);

INSERT INTO dcsa_im_v3_0.operations_event (
    event_id,
    event_classifier_code,
    event_date_time,
    event_created_date_time,
    operations_event_type_code,
    transport_call_id,
    delay_reason_code,
    publisher_role,
    port_call_service_type_code,
    event_location,
    facility_type_code,
    publisher
) VALUES (
    uuid('a0993e06-a222-42ec-816f-ec1d775cfd10'),
    'ACT',
    TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),
    '2022-05-08T13:22:53Z',
    'DEPA',
    'b785317a-2340-4db7-8fb3-c8dfb1edfa60'::uuid,
    'ANA',
    'TR',
    'BUNK',
    '06aca2f6-f1d0-48f8-ba46-9a3480adfd23',
    'BRTH',
    'be5bc290-7bac-48bb-a211-f3fa5a3ab3ae'
), (
    uuid('03482296-ef9c-11eb-9a03-0242ac130003'),
    'EST',
    TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),
    '2022-02-08T13:22:53Z',
    'ARRI',
    '7f2d833c-2c7f-4fc5-a71a-e510881da64a'::uuid,
    'ANA',
    'CA',
    'WSDP',
    '6748a259-fb7e-4f27-9a88-3669e8b9c5f8',
    'BRTH',
    'be5bc290-7bac-48bb-a211-f3fa5a3ab3ae'
);

SELECT 'End: 08_03_test_data_ovs.sql' as progress;

COMMIT;

-- REMOVE DATA OVERLAPPING WITH 08_02_test_data_tnt.sql
