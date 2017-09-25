CLASS zcl_blockchain_console_app DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_blockchain_console_app IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA(lo_cf_service_mgr) = cl_cf_servicemanager=>get_instance( ).

    DATA(lo_cf_service) = lo_cf_service_mgr->get_service(
        service_name            = 'Hello World!'
        use_default_service_key = abap_true
    ).

    DATA(lo_blockchain) = NEW zcl_blockchain_service( lo_cf_service ).

    DATA(lv_result) = lo_blockchain->read(
        chaincode_id    = 'b1008afa8fcea53106ac3a938816fdf2'
        argument        = 'X5123'
    ).

    out->write_text( |Query-Result: { lv_result }| ).
  ENDMETHOD.

ENDCLASS.
