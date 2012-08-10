!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!                              Copyright (C) 2012                              !
!                   The Regents of the University of Michigan                  !
!              MPACT Development Group and Prof. Thomas J. Downar              !
!                             All rights reserved.                             !
!                                                                              !
! Copyright is reserved to the University of Michigan for purposes of          !
! controlled dissemination, commercialization through formal licensing, or     !
! other disposition. The University of Michigan nor any of their employees,    !
! makes any warranty, express or implied, or assumes any liability or          !
! responsibility for the accuracy, completeness, or usefulness of any          !
! information, apparatus, product, or process disclosed, or represents that    !
! its use would not infringe privately owned rights. Reference herein to any   !
! specific commercial products, process, or service by trade name, trademark,  !
! manufacturer, or otherwise, does not necessarily constitute or imply its     !
! endorsement, recommendation, or favoring by the University of Michigan.      !
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
PROGRAM testParameterLists
  
  USE ISO_FORTRAN_ENV
  USE IntrType
  USE Strings
  USE ExceptionHandler
  USE ParameterLists
  IMPLICIT NONE
  
  REAL(SSK) :: valssk
  REAL(SDK) :: valsdk
  INTEGER(SNK) :: valsnk
  INTEGER(SLK) :: valslk
  LOGICAL(SBK) :: valsbk
  TYPE(ExceptionHandlerType),POINTER :: e
  
  TYPE(ParamType) :: testParam,testParam2,testList(5),testList2(3)
  CLASS(ParamType),POINTER :: someParam
  
  WRITE(*,*) '==================================================='
  WRITE(*,*) 'TESTING PARAMETERLISTS...'
  WRITE(*,*) '==================================================='
  
  ALLOCATE(e)
  CALL e%setStopOnError(.FALSE.)
  CALL e%setQuietMode(.TRUE.)
  eParams => e
  !Test the parameter type list
  WRITE(*,*) '---------------------------------------------------'
  WRITE(*,*) 'TESTING  PARAMETER TYPE LISTS...'
  CALL testParamListType()
  !Test the scalar SSK parameter list
  WRITE(*,*) '---------------------------------------------------'
  WRITE(*,*) 'TESTING Scalar SSK PARAMETERLISTS...'
  CALL testSSK()
  !Test the scalar SDK parameter list
  WRITE(*,*) '---------------------------------------------------'
  WRITE(*,*) 'TESTING Scalar SDK PARAMETERLISTS...'
  CALL testSDK()
  !Test the scalar SNK parameter list
  !WRITE(*,*) '---------------------------------------------------'
  !WRITE(*,*) 'TESTING Scalar SNK PARAMETERLISTS...'
  !CALL testSNK()
  !!Test the scalar SLK parameter list
  !WRITE(*,*) '---------------------------------------------------'
  !WRITE(*,*) 'TESTING Scalar SLK PARAMETERLISTS...'
  !CALL testSLK()
  !!Test the scalar SBK parameter list
  !WRITE(*,*) '---------------------------------------------------'
  !WRITE(*,*) 'TESTING Scalar SBK PARAMETERLISTS...'
  !CALL testSBK()
  
  CALL testClear()
  
  !Test add routines
  WRITE(*,*) '---------------------------------------------------'
  WRITE(*,*) 'TESTING Add Routines...'
  
  CALL e%setQuietMode(.FALSE.)
  eParams => NULL()
  CALL testParam%add('testSSK',6.0_SSK)
  CALL testParam%edit(OUTPUT_UNIT)
  eParams => e
  CALL testParam%add('testSSK',7.0_SSK)
  CALL testParam%add('testSSK2',7.0_SSK)
  CALL testParam%clear()
  CALL testParam%add('testPL->testSSK',7.0_SSK)
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%add('testPL->testSSK2',8.0_SSK)
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%add('testSSK',9.0_SSK)
  CALL testParam%add('testPL2->testSSK',9.0_SSK,'Creates a new sublist')
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%add('testPL2->testSSK',9.0_SSK)
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%add('testPL2->testSSK2',-10.0e5_SSK)
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%add('testPL->testPL2->testSSK',11.0)
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%add('testPL->testPL2->testSSK3',11.0e6_SSK)
  CALL testParam%edit(OUTPUT_UNIT)
  eParams => NULL()
  CALL testParam2%add('testPL3->sublist1',testParam)
  CALL testParam2%edit(OUTPUT_UNIT)
  
  
  CALL testParam2%clear()
  CALL testParam2%add('testList->List1',testList)
  CALL testParam2%add('List2',testList2,'Empty list')
  CALL testParam2%edit(OUTPUT_UNIT)
  eParams => e
  CALL testParam2%add('List2',testList2,'Empty list')
  
  WRITE(*,*) '---------------------------------------------------'
  WRITE(*,*) 'TESTING Remove Routines...'
  !test remove
  CALL testParam%edit(OUTPUT_UNIT)
  eParams => NULL()
  CALL testParam%remove('testSSK3')
  eParams => e
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%remove('->error')
  CALL testParam%remove('testSSK')
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%remove('testPL2->testSSK2')
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%remove('testPL2')
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%remove('testPL2')
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%remove('testPL->testSSK2')
  CALL testParam%edit(OUTPUT_UNIT)
  CALL testParam%remove('testPL->testSSK2')
  CALL testParam%remove('testPL2->testSSK2')
  
  !Clean-up variables
  CALL testParam2%clear()
  CALL testParam%clear()
  
  !Setup reference list
  CALL testParam2%add('TestReq->p1',0.0_SSK)
  CALL testParam2%add('TestReq->p2',0.1_SSK)
  CALL testParam2%add('TestReq->sublist1->p1',1.0_SSK)
  CALL testParam2%add('TestReq->sublist1->p3',1.1_SSK)
  CALL testParam2%add('TestReq->sublist1->sublist2->p2',2.0_SSK)
  CALL testParam2%add('TestReq->sublist1->sublist2->sublist3->null',-1.0_SSK)
  CALL testParam2%remove('TestReq->sublist1->sublist2->sublist3->null')
  CALL testParam2%add('TestReq->p4',0.2_SSK)
  CALL testParam2%edit(OUTPUT_UNIT)

  WRITE(*,*) '==================================================='
  WRITE(*,*) 'TESTING PARAMETERLISTS PASSED!'
  WRITE(*,*) '==================================================='  
!
!===============================================================================
  CONTAINS
!
!-------------------------------------------------------------------------------
!
!Test SSK support
  SUBROUTINE testSSK()
    ALLOCATE(testParam2%pdat)
    testParam2%pdat%name='testSSK'
    valssk=5._SSK
    !test init
    CALL testParam%init('testError->testSSK',valssk,'The number 5.0')
    eParams => NULL()
    CALL testParam%init('testSSK',valssk,'The number 5.0')
    IF(.NOT.ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%init(...) %pdat (SSK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%name /= 'testSSK') THEN
      WRITE(*,*) 'CALL testParam%init(...) %name (SSK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%datatype /= 'REAL(SSK)') THEN
      WRITE(*,*) 'CALL testParam%init(...) %datatype (SSK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%description /= 'The number 5.0') THEN
      WRITE(*,*) 'CALL testParam%init(...) %description (SSK) FAILED!'
      STOP 666
    ENDIF
    CALL testParam%edit(OUTPUT_UNIT,0) !test edit
    eParams => e
    CALL testParam%init('testError',valssk)
    WRITE(*,*) '  Passed: CALL testParam%init(...) (SSK)'
  
    !test get
    eParams => NULL()
    CALL testParam%get('testSSK',someParam)
    IF(.NOT.ASSOCIATED(someParam,testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%get(''testSSK'',someParam) FAILED!'
      STOP 666
    ENDIF
    CALL someParam%get('testSSK',valssk)
    IF(valssk /= 5.0_SSK) THEN
      WRITE(*,*) 'CALL someParam%get(''testSSK'',valssk) FAILED!'
      STOP 666
    ENDIF
    valssk=0.0_SSK
    CALL testParam%get('testSSK',valssk)
    IF(valssk /= 5.0_SSK) THEN
      WRITE(*,*) 'CALL testParam%get(''testSSK'',valssk) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%get('testSSK',valssk)
    CALL testParam%get('testError',valssk)
    CALL someParam%get('testError',valssk)
    WRITE(*,*) '  Passed: CALL testParam%get(...) (SSK)'
  
    !test set
    eParams => NULL()
    CALL someParam%set('testSSK',3.0_SSK,'The number 3.0')
    CALL testParam%get('testSSK',valssk)
    IF(valssk /= 3.0_SSK .OR. someParam%description /= 'The number 3.0') THEN
      WRITE(*,*) 'someParam%set(''testSSK'',3.0_SSK,''The number 3.0'') FAILED!'
      STOP 666
    ENDIF
    CALL testParam%set('testSSK',5.0_SSK,'The number 5.0')
    CALL testParam%get('testSSK',valssk)
    IF(valssk /= 5.0_SSK .OR. someParam%description /= 'The number 5.0') THEN
      WRITE(*,*) 'testParam%set(''testSSK'',5.0_SSK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%set('testSSK',valssk)
    CALL someParam%set('testError',valssk)
    CALL testParam%set('testError',valssk)
    WRITE(*,*) '  Passed: CALL testParam%set(...) (SSK)'
  
    !Test clear
    eParams => NULL()
    CALL testParam%clear()
    IF(LEN(testParam%name%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %name (SSK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%datatype%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %datatype (SSK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%description%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %description (SSK) FAILED!'
      STOP 666
    ENDIF
    IF(ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%clear() %pdat (SSK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    WRITE(*,*) '  Passed: CALL testParam%clear() (SSK)'
  
    !test assignment
    eParams => NULL()
    CALL testParam%init('testSSK',4.0_SSK)
    testParam2=testparam
    IF(.NOT.ASSOCIATED(testParam2%pdat)) THEN
      WRITE(*,*) 'ASSIGNMENT(=) %pdat (SSK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%name /= 'testSSK') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %name (SSK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%datatype /= 'REAL(SSK)') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %datatype (SSK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam%get('testSSK',someParam)
    someParam=testParam
    WRITE(*,*) '  Passed: ASSIGNMENT(=) (SSK)'
    !Clear the variables
    CALL testClear()
    
  ENDSUBROUTINE testSSK
!
!Test ParamList support
  SUBROUTINE testParamListType()
    !Carry over from testSSK
    CALL testParam%init('testSSK',4.0_SSK)
    CALL testParam%get('testSSK',someParam)
    someParam=testParam
    !
    testList(1)=testParam
    CALL testParam%clear()
    CALL testParam2%clear()
    ALLOCATE(testParam2%pdat)
    testParam2%pdat%name='testPL'
  
    !test init
    CALL testParam%init('testError->testPL',testList)
    eParams => NULL()
    CALL testParam%init('testPL',testList,'A test parameter list')
    IF(.NOT.ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%init(...) %pdat (List) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%name /= 'testPL') THEN
      WRITE(*,*) 'CALL testParam%init(...) %name (List) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%datatype /= 'TYPE(ParamType_List)') THEN
      WRITE(*,*) 'CALL testParam%init(...) %datatype (List) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%description /= 'A test parameter list') THEN
      WRITE(*,*) 'CALL testParam%init(...) %description (List) FAILED!'
      STOP 666
    ENDIF
    CALL testParam%edit(OUTPUT_UNIT,0) !test edit
    eParams => e
    CALL testParam%init('testError',testList,'A test parameter list')
    WRITE(*,*) '  Passed: CALL testParam%init(...) (List)'
  
    !Test get
    eParams => NULL()
    CALL testParam%get('testPL',someParam)
    CALL someParam%get('testPL',testList)
    IF(testList(1)%pdat%name /= 'testSSK') THEN
      WRITE(*,*) 'CALL someParam%get(''testPL'',testList) FAILED!'
      STOP 666
    ENDIF
    CALL testParam%get('testPL',testList)
    IF(testList(1)%pdat%name /= 'testSSK') THEN
      WRITE(*,*) 'CALL testParam%get(''testPL'',testList) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL someParam%get('testPL',testList2)
    CALL testParam%get('testPL',testList2)
    CALL testParam2%get('testPL',testList2)
    CALL testParam%get('testError',testList2)
    CALL testParam%get('->testError',testList2)
    CALL someParam%get('testError',testList2)
    WRITE(*,*) '  Passed: CALL testParam%get(...) (List)'
  
    !Test set
    !testList(2)=testList(1) GNU does not like this, seems to use the intrinsic assignment
    !                        rather than the overloaded assignment and produces a run
    !                        time error in memcopy instead of calling assign_ParamType.
    testParam2=testList(1)
    testList(2)=testParam2
    testList(2)%pdat%name='testSSK2'
    eParams => NULL()
    CALL someParam%set('testPL',testList,'A second list')
    valssk=0.0_SSK
    CALL testParam%edit(OUTPUT_UNIT)
    CALL testParam%get('testSSK2',valssk)
    IF(valssk /= 4.0_SSK .OR. someParam%description /= 'A second list') THEN
      WRITE(*,*) 'CALL someParam%set(''testPL'',testList,''A second list'') FAILED!'
      STOP 666
    ENDIF
    CALL testList(2)%clear()
    CALL testParam%set('testPL',testList,'A test parameter list')
    valssk=0.0_SSK
    eParams => e
    CALL testParam%get('testPL->testSSK2',valssk)
    IF(valssk /= 0.0_SSK .OR. someParam%description /= 'A test parameter list') THEN
      WRITE(*,*) 'CALL testParam%set(''testPL'',testList,''A test parameter list'') FAILED!'
      STOP 666
    ENDIF
    CALL testParam%set('testPL',testList2)
    CALL someParam%set('testPL',testList2)
    CALL testParam2%set('testSSK',testList)
    CALL someParam%set('testError',testList)
    CALL testParam%set('testError',testList)
    WRITE(*,*) '  Passed: CALL testParam%set(...) (List)'
  
    !test clear
    eParams => NULL()
    CALL testParam%clear()
    IF(LEN(testParam%name%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %name (List) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%datatype%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %datatype (List) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%description%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %description (List) FAILED!'
      STOP 666
    ENDIF
    IF(ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%clear() %pdat (List) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    WRITE(*,*) '  Passed: CALL testParam%clear() (List)'
  
    !Test assignment
    CALL testParam%init('testPL',testList)
    testParam2=testParam
    IF(.NOT.ASSOCIATED(testParam2%pdat)) THEN
      WRITE(*,*) 'ASSIGNMENT(=) %pdat (List) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%name /= 'testPL') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %name (List) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%datatype /= 'TYPE(ParamType_List)') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %datatype (List) FAILED!'
      STOP 666
    ENDIF
    WRITE(*,*) '  Passed: ASSIGNMENT(=) (List)'
  
    CALL testClear()
    
  ENDSUBROUTINE testParamListType
  
  !Clear all the test variables
  SUBROUTINE testClear()
    
    CALL testParam%clear()
    CALL testParam2%clear()
    CALL testList(1)%clear()
    CALL testList(2)%clear()
    CALL testList(3)%clear()
    CALL testList(4)%clear()
    CALL testList(5)%clear()
    CALL testList2(1)%clear()
    CALL testList2(2)%clear()
    CALL testList2(3)%clear()
  
  ENDSUBROUTINE testClear
!
!Test SDK support
  SUBROUTINE testSDK()
    ALLOCATE(testParam2%pdat)
    testParam2%pdat%name='testSDK'
    valsdk=5._SDK
    !test init
    CALL testParam%init('testError->testSDK',valsdk,'The number 5.0')
    eParams => NULL()
    CALL testParam%init('testSDK',valsdk,'The number 5.0')
    IF(.NOT.ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%init(...) %pdat (SDK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%name /= 'testSDK') THEN
      WRITE(*,*) 'CALL testParam%init(...) %name (SDK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%datatype /= 'REAL(SDK)') THEN
      WRITE(*,*) 'CALL testParam%init(...) %datatype (SDK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%description /= 'The number 5.0') THEN
      WRITE(*,*) 'CALL testParam%init(...) %description (SDK) FAILED!'
      STOP 666
    ENDIF
    CALL testParam%edit(OUTPUT_UNIT,0) !test edit
    eParams => e
    CALL testParam%init('testError',valsdk)
    WRITE(*,*) '  Passed: CALL testParam%init(...) (SDK)'
  
    !test get
    eParams => NULL()
    CALL testParam%get('testSDK',someParam)
    IF(.NOT.ASSOCIATED(someParam,testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%get(''testSDK'',someParam) FAILED!'
      STOP 666
    ENDIF
    CALL someParam%get('testSDK',valsdk)
    IF(valsdk /= 5.0_SDK) THEN
      WRITE(*,*) 'CALL someParam%get(''testSDK'',valsdk) FAILED!'
      STOP 666
    ENDIF
    valsdk=0.0_SDK
    CALL testParam%get('testSDK',valsdk)
    IF(valsdk /= 5.0_SDK) THEN
      WRITE(*,*) 'CALL testParam%get(''testSDK'',valsdk) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%get('testSDK',valsdk)
    CALL testParam%get('testError',valsdk)
    CALL someParam%get('testError',valsdk)
    WRITE(*,*) '  Passed: CALL testParam%get(...) (SDK)'
  
    !test set
    eParams => NULL()
    CALL someParam%set('testSDK',3.0_SDK,'The number 3.0')
    CALL testParam%get('testSDK',valsdk)
    IF(valsdk /= 3.0_SDK .OR. someParam%description /= 'The number 3.0') THEN
      WRITE(*,*) 'someParam%set(''testSDK'',3.0_SDK,''The number 3.0'') FAILED!'
      STOP 666
    ENDIF
    CALL testParam%set('testSDK',5.0_SDK,'The number 5.0')
    CALL testParam%get('testSDK',valsdk)
    IF(valsdk /= 5.0_SDK .OR. someParam%description /= 'The number 5.0') THEN
      WRITE(*,*) 'testParam%set(''testSDK'',5.0_SDK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%set('testSDK',valsdk)
    CALL someParam%set('testError',valsdk)
    CALL testParam%set('testError',valsdk)
    WRITE(*,*) '  Passed: CALL testParam%set(...) (SDK)'
  
    !Test clear
    eParams => NULL()
    CALL testParam%clear()
    IF(LEN(testParam%name%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %name (SDK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%datatype%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %datatype (SDK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%description%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %description (SDK) FAILED!'
      STOP 666
    ENDIF
    IF(ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%clear() %pdat (SDK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    WRITE(*,*) '  Passed: CALL testParam%clear() (SDK)'
  
    !test assignment
    eParams => NULL()
    CALL testParam%init('testSDK',4.0_SDK)
    testParam2=testparam
    IF(.NOT.ASSOCIATED(testParam2%pdat)) THEN
      WRITE(*,*) 'ASSIGNMENT(=) %pdat (SDK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%name /= 'testSDK') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %name (SDK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%datatype /= 'REAL(SDK)') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %datatype (SDK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam%get('testSDK',someParam)
    someParam=testParam
    WRITE(*,*) '  Passed: ASSIGNMENT(=) (SDK)'
    !Clear the variables for the next call
    CALL testClear()
    
  ENDSUBROUTINE testSDK
!
!Test SNK support
  SUBROUTINE testSNK()
    ALLOCATE(testParam2%pdat)
    testParam2%pdat%name='testSNK'
    valsnk=5_SNK
    !test init
    CALL testParam%init('testError->testSNK',valsnk,'The number 5')
    eParams => NULL()
    CALL testParam%init('testSNK',valsnk,'The number 5')
    IF(.NOT.ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%init(...) %pdat (SNK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%name /= 'testSNK') THEN
      WRITE(*,*) 'CALL testParam%init(...) %name (SNK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%datatype /= 'INTEGER(SNK)') THEN
      WRITE(*,*) 'CALL testParam%init(...) %datatype (SNK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%description /= 'The number 5') THEN
      WRITE(*,*) 'CALL testParam%init(...) %description (SNK) FAILED!'
      STOP 666
    ENDIF
    CALL testParam%edit(OUTPUT_UNIT,0) !test edit
    eParams => e
    CALL testParam%init('testError',valsnk)
    WRITE(*,*) '  Passed: CALL testParam%init(...) (SNK)'
  
    !test get
    eParams => NULL()
    CALL testParam%get('testSNK',someParam)
    IF(.NOT.ASSOCIATED(someParam,testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%get(''testSNK'',someParam) FAILED!'
      STOP 666
    ENDIF
    CALL someParam%get('testSNK',valsnk)
    IF(valsnk /= 5_SNK) THEN
      WRITE(*,*) 'CALL someParam%get(''testSNK'',valsnk) FAILED!'
      STOP 666
    ENDIF
    valsnk=0_SNK
    CALL testParam%get('testSNK',valsnk)
    IF(valsnk /= 5_SNK) THEN
      WRITE(*,*) 'CALL testParam%get(''testSNK'',valsnk) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%get('testSNK',valsnk)
    CALL testParam%get('testError',valsnk)
    CALL someParam%get('testError',valsnk)
    WRITE(*,*) '  Passed: CALL testParam%get(...) (SNK)'
  
    !test set
    eParams => NULL()
    CALL someParam%set('testSNK',3_SNK,'The number 3')
    CALL testParam%get('testSNK',valsnk)
    IF(valsnk /= 3_SNK .OR. someParam%description /= 'The number 3') THEN
      WRITE(*,*) 'someParam%set(''testSNK'',3_SNK,''The number 3'') FAILED!'
      STOP 666
    ENDIF
    CALL testParam%set('testSNK',5_SNK,'The number 5')
    CALL testParam%get('testSNK',valsnk)
    IF(valsnk /= 5_SNK .OR. someParam%description /= 'The number 5') THEN
      WRITE(*,*) 'testParam%set(''testSNK'',5_SNK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%set('testSNK',valsnk)
    CALL someParam%set('testError',valsnk)
    CALL testParam%set('testError',valsnk)
    WRITE(*,*) '  Passed: CALL testParam%set(...) (SNK)'
  
    !Test clear
    eParams => NULL()
    CALL testParam%clear()
    IF(LEN(testParam%name%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %name (SNK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%datatype%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %datatype (SNK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%description%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %description (SNK) FAILED!'
      STOP 666
    ENDIF
    IF(ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%clear() %pdat (SNK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    WRITE(*,*) '  Passed: CALL testParam%clear() (SNK)'
  
    !test assignment
    eParams => NULL()
    CALL testParam%init('testSNK',4_SNK)
    testParam2=testparam
    IF(.NOT.ASSOCIATED(testParam2%pdat)) THEN
      WRITE(*,*) 'ASSIGNMENT(=) %pdat (SNK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%name /= 'testSNK') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %name (SNK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%datatype /= 'INTEGER(SNK)') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %datatype (SNK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam%get('testSNK',someParam)
    someParam=testParam
    WRITE(*,*) '  Passed: ASSIGNMENT(=) (SNK)'
    !Clear the variables for the next call
    CALL testClear()
    
  ENDSUBROUTINE testSNK
!
!Test SLK support
  SUBROUTINE testSLK()
    ALLOCATE(testParam2%pdat)
    testParam2%pdat%name='testSLK'
    valslk=5_SLK
    !test init
    CALL testParam%init('testError->testSLK',valslk,'The number 5')
    eParams => NULL()
    CALL testParam%init('testSLK',valslk,'The number 5')
    IF(.NOT.ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%init(...) %pdat (SLK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%name /= 'testSLK') THEN
      WRITE(*,*) 'CALL testParam%init(...) %name (SLK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%datatype /= 'INTEGER(SLK)') THEN
      WRITE(*,*) 'CALL testParam%init(...) %datatype (SLK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%description /= 'The number 5') THEN
      WRITE(*,*) 'CALL testParam%init(...) %description (SLK) FAILED!'
      STOP 666
    ENDIF
    CALL testParam%edit(OUTPUT_UNIT,0) !test edit
    eParams => e
    CALL testParam%init('testError',valslk)
    WRITE(*,*) '  Passed: CALL testParam%init(...) (SLK)'
  
    !test get
    eParams => NULL()
    CALL testParam%get('testSLK',someParam)
    IF(.NOT.ASSOCIATED(someParam,testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%get(''testSLK'',someParam) FAILED!'
      STOP 666
    ENDIF
    CALL someParam%get('testSLK',valslk)
    IF(valslk /= 5_SLK) THEN
      WRITE(*,*) 'CALL someParam%get(''testSLK'',valslk) FAILED!'
      STOP 666
    ENDIF
    valslk=0_SLK
    CALL testParam%get('testSLK',valslk)
    IF(valslk /= 5_SLK) THEN
      WRITE(*,*) 'CALL testParam%get(''testSLK'',valslk) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%get('testSLK',valslk)
    CALL testParam%get('testError',valslk)
    CALL someParam%get('testError',valslk)
    WRITE(*,*) '  Passed: CALL testParam%get(...) (SLK)'
  
    !test set
    eParams => NULL()
    CALL someParam%set('testSLK',3_SLK,'The number 3')
    CALL testParam%get('testSLK',valslk)
    IF(valslk /= 3_SLK .OR. someParam%description /= 'The number 3') THEN
      WRITE(*,*) 'someParam%set(''testSLK'',3_SLK,''The number 3'') FAILED!'
      STOP 666
    ENDIF
    CALL testParam%set('testSLK',5_SLK,'The number 5')
    CALL testParam%get('testSLK',valslk)
    IF(valslk /= 5_SLK .OR. someParam%description /= 'The number 5') THEN
      WRITE(*,*) 'testParam%set(''testSLK'',5_SLK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%set('testSLK',valslk)
    CALL someParam%set('testError',valslk)
    CALL testParam%set('testError',valslk)
    WRITE(*,*) '  Passed: CALL testParam%set(...) (SLK)'
  
    !Test clear
    eParams => NULL()
    CALL testParam%clear()
    IF(LEN(testParam%name%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %name (SLK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%datatype%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %datatype (SLK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%description%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %description (SLK) FAILED!'
      STOP 666
    ENDIF
    IF(ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%clear() %pdat (SLK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    WRITE(*,*) '  Passed: CALL testParam%clear() (SLK)'
  
    !test assignment
    eParams => NULL()
    CALL testParam%init('testSLK',4_SLK)
    testParam2=testparam
    IF(.NOT.ASSOCIATED(testParam2%pdat)) THEN
      WRITE(*,*) 'ASSIGNMENT(=) %pdat (SLK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%name /= 'testSLK') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %name (SLK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%datatype /= 'INTEGER(SLK)') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %datatype (SLK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam%get('testSLK',someParam)
    someParam=testParam
    WRITE(*,*) '  Passed: ASSIGNMENT(=) (SLK)'
    !Clear the variables for the next call
    CALL testClear()
    
  ENDSUBROUTINE testSLK
!
!Test SBK support
  SUBROUTINE testSBK()
    ALLOCATE(testParam2%pdat)
    testParam2%pdat%name='testSBK'
    valsbk=.TRUE.
    !test init
    CALL testParam%init('testError->testSBK',valsbk,'The value is TRUE')
    eParams => NULL()
    CALL testParam%init('testSBK',valsbk,'The value is TRUE')
    IF(.NOT.ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%init(...) %pdat (SBK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%name /= 'testSBK') THEN
      WRITE(*,*) 'CALL testParam%init(...) %name (SBK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%datatype /= 'LOGICAL(SBK)') THEN
      WRITE(*,*) 'CALL testParam%init(...) %datatype (SBK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam%pdat%description /= 'The value is TRUE') THEN
      WRITE(*,*) 'CALL testParam%init(...) %description (SBK) FAILED!'
      STOP 666
    ENDIF
    CALL testParam%edit(OUTPUT_UNIT,0) !test edit
    eParams => e
    CALL testParam%init('testError',valsbk)
    WRITE(*,*) '  Passed: CALL testParam%init(...) (SBK)'
  
    !test get
    eParams => NULL()
    CALL testParam%get('testSBK',someParam)
    IF(.NOT.ASSOCIATED(someParam,testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%get(''testSBK'',someParam) FAILED!'
      STOP 666
    ENDIF
    CALL someParam%get('testSBK',valsbk)
    IF(.NOT.valsbk) THEN
      WRITE(*,*) 'CALL someParam%get(''testSBK'',valsbk) FAILED!'
      STOP 666
    ENDIF
    valsbk=.FALSE.
    CALL testParam%get('testSBK',valsbk)
    IF(.NOT.valsbk) THEN
      WRITE(*,*) 'CALL testParam%get(''testSBK'',valsbk) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%get('testSBK',valsbk)
    CALL testParam%get('testError',valsbk)
    CALL someParam%get('testError',valsbk)
    WRITE(*,*) '  Passed: CALL testParam%get(...) (SBK)'
  
    !test set
    eParams => NULL()
    CALL someParam%set('testSBK',.TRUE.,'The value is TRUE')
    CALL testParam%get('testSBK',valsbk)
    IF(.NOT.valsbk .OR. someParam%description /= 'The value is TRUE') THEN
      WRITE(*,*) 'someParam%set(''testSBK'',TRUE,''The value is TRUE'') FAILED!'
      STOP 666
    ENDIF
    CALL testParam%set('testSBK',.FALSE.,'The value is FALSE')
    CALL testParam%get('testSBK',valsbk)
    IF(valsbk .OR. someParam%description /= 'The value is FALSE') THEN
      WRITE(*,*) 'testParam%set(''testSBK'',FALSE) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam2%set('testSBK',valsbk)
    CALL someParam%set('testError',valsbk)
    CALL testParam%set('testError',valsbk)
    WRITE(*,*) '  Passed: CALL testParam%set(...) (SBK)'
  
    !Test clear
    eParams => NULL()
    CALL testParam%clear()
    IF(LEN(testParam%name%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %name (SBK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%datatype%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %datatype (SBK) FAILED!'
      STOP 666
    ENDIF
    IF(LEN(testParam%description%sPrint()) /= 0) THEN
      WRITE(*,*) 'CALL testParam%clear() %description (SBK) FAILED!'
      STOP 666
    ENDIF
    IF(ASSOCIATED(testParam%pdat)) THEN
      WRITE(*,*) 'CALL testParam%clear() %pdat (SBK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    WRITE(*,*) '  Passed: CALL testParam%clear() (SBK)'
  
    !test assignment
    eParams => NULL()
    CALL testParam%init('testSBK',.TRUE.)
    testParam2=testparam
    IF(.NOT.ASSOCIATED(testParam2%pdat)) THEN
      WRITE(*,*) 'ASSIGNMENT(=) %pdat (SBK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%name /= 'testSBK') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %name (SBK) FAILED!'
      STOP 666
    ENDIF
    IF(testParam2%pdat%datatype /= 'LOGICAL(SBK)') THEN
      WRITE(*,*) 'ASSIGNMENT(=) %datatype (SBK) FAILED!'
      STOP 666
    ENDIF
    eParams => e
    CALL testParam%get('testSBK',someParam)
    someParam=testParam
    WRITE(*,*) '  Passed: ASSIGNMENT(=) (SBK)'
    !Clear the variables for the next call
    CALL testClear()
    
  ENDSUBROUTINE testSBK

!
ENDPROGRAM testParameterLists
