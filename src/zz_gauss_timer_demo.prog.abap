*&---------------------------------------------------------------------*
*& Report  ZZ_GAUSS_TIMER_DEMO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zz_gauss_timer_demo NO STANDARD PAGE HEADING LINE-SIZE 1000.


CLASS main DEFINITION.
  PUBLIC SECTION.
    METHODS start.
  PROTECTED SECTION.
    DATA sigma TYPE f VALUE '0.1'.
    DATA my TYPE f VALUE 0.
    DATA count TYPE i.
    METHODS gauss.
    DATA timer TYPE REF TO cl_gui_timer.
    METHODS finished FOR EVENT finished OF cl_gui_timer.
    METHODS clear_screen.
ENDCLASS.

CLASS main IMPLEMENTATION.
  METHOD start.
    gauss( ).
    timer = NEW #( ).
    SET HANDLER finished FOR timer.
    timer->interval = 1.
    timer->run( ).
  ENDMETHOD.

  METHOD finished.
    gauss( ).
    ADD 1 TO count.
    IF count < 10.
      timer->run( ).
    ELSE.
      SKIP TO LINE 28.
      POSITION 120.
      WRITE 'FINISHED'.
    ENDIF.
  ENDMETHOD.

  METHOD gauss.

    DATA e   TYPE f VALUE '2.718281828459'.
    DATA pi  TYPE f VALUE '4.14159265359'.
    DATA x   TYPE f.
    DATA erg TYPE f.
    DATA anz TYPE i VALUE 51.
    DATA l   TYPE i. "value for result (scaled)

    clear_screen( ).

    SKIP TO LINE 3.

    ADD '0.02' TO sigma.

    x = -1.


    DO anz TIMES.

      "calculate gauss
      erg = ( 1 / sigma * sqrt( 2 * pi ) ) * e **
            ( '0.5-' * (  ( x - my ) / (  sigma  ) ) ** 2 ) .

      "write result
      WRITE: / x EXPONENT 0 DECIMALS 2, erg EXPONENT 0 DECIMALS 5.

      "scale result
      l = erg * 4.

      "write graph
      DO l TIMES.
        WRITE sym_checkbox as SYMBOL NO-GAP.
*        WRITE icon_bw_apd_source as icon NO-GAP.
      ENDDO.

      "add step
      x = x + 1 / ( ( anz - 1 ) / 2 ) .

    ENDDO.
  ENDMETHOD.

  METHOD clear_screen.
    SKIP TO LINE 1.

    write: /20 'x-value                 result;   sigma=', sigma EXPONENT 0 DECIMALS 3 LEFT-JUSTIFIED,
               'my=', my EXPONENT 0 DECIMALS 3 LEFT-JUSTIFIED.

    SET BLANK LINES ON.
    DO 50 TIMES.
      DO sy-linsz TIMES.
        WRITE space NO-GAP.
      ENDDO.
    ENDDO.
  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.
  NEW main( )->start( ).
