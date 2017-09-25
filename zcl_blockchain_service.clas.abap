CLASS zcl_blockchain_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS
      constructor
        IMPORTING
          service TYPE REF TO if_cf_service.
    METHODS
      read
        IMPORTING
          chaincode_id           TYPE string
          argument               TYPE string
        RETURNING
          VALUE(rv_query_result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      tt_args TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
      BEGIN OF ts_query,
        fcn          TYPE string,
        args         TYPE tt_args,
        chaincode_id TYPE string,
      END OF ts_query.
    DATA:
      go_cf_service TYPE REF TO if_cf_service.
    METHODS create_read_query_body
      IMPORTING
        iv_chaincode_id TYPE string
        iv_argument     TYPE string
      RETURNING
        VALUE(rv_body)  TYPE string.
ENDCLASS.



CLASS zcl_blockchain_service IMPLEMENTATION.
  METHOD constructor.
    go_cf_service = service.
  ENDMETHOD.


  METHOD read.
    DATA(lv_body) = me->create_read_query_body(
        iv_chaincode_id = chaincode_id
        iv_argument     = argument
    ).

    rv_query_result = go_cf_service->post( lv_body )->get_body( ).
  ENDMETHOD.

  METHOD create_read_query_body.
    " fill target structure
    DATA(ls_query) = VALUE ts_query(
        fcn          = 'read'
        args         = VALUE tt_args( ( iv_argument )  )
        chaincode_id = iv_chaincode_id
    ).

    " convert to json
    rv_body = /ui2/cl_json=>serialize(
        data             = ls_query    " Data to serialize
        pretty_name      = /ui2/cl_json=>pretty_mode-camel_case    " Pretty Print property names
    ).
  ENDMETHOD.

ENDCLASS.
