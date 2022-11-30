
DEFINE CLASS RegionalFactory as Session
* Factory de regional
* las regiones son singletton

*-------------------------------FACTORY---------------------------------------	
	FUNCTION getRegional
	LPARAMETERS tcCodigoRegional 
		SET STEP ON 
		LOCAL lcClaseRegional, lcVarRegion, loError
		tcCodigoRegional  = UPPER(ALLTRIM(tcCodigoRegional))
		TRY	
			DO CASE 
				CASE tcCodigoRegional  = "ARG"
					lcClaseRegional="RegionalArg"
				CASE tcCodigoRegional  = "PAR"
					lcClaseRegional="RegionalPar"
				CASE tcCodigoRegional  = "URU"
					lcClaseRegional="RegionalUru"
				OTHERWISE 
					THROW "No existe la region" + tcCodigoRegional 
			ENDCASE 
			**Verificamos si existe la propiedad en el screen y si es de tipo Obj
			IF TYPE("_screen.oBj_Regional") != "O"
			
				REMOVEPROPERTY(_screen,"oBj_Regional")
                ADDPROPERTY(_screen,"oBj_Regional",NEWOBJECT(lcClaseRegional,"regional.prg"))
                
			ENDIF 
                	               
           
		CATCH TO loError
			this.setlog(loError.message)
		ENDTRY 
		
	
	RETURN _screen.oBj_Regional
	ENDFUNC 
	
	
ENDDEFINE 

** mxcorenegocio 
**Cambiar a mxsesion 
DEFINE CLASS Regional as Session

*-------------------------------PROPIEDADES-----------------------------------
	cPais=""
	nCod_pais=""
	cMoneda=""
	cAcronimoMoneda=""
	cMascaraTributaria=""
	cSiglaTributaria =""
	


*-------------------------------CONSTRUCTOR----------------------------------	
	FUNCTION init
		
	ENDFUNC 
*-------------------------------GET------------------------------------------
	FUNCTION getcSiglaTributaria (cSiglaTributaria)
		RETURN this.cSiglaTributaria 
	ENDFUNC
	
	FUNCTION getcMascaraTributaria (cMascaraTributaria)
		RETURN this.cMascaraTributaria 
	ENDFUNC
	
	FUNCTION getcAcronimoMoneda (cAcronimoMoneda)
		RETURN this.cAcronimoMoneda 
	ENDFUNC
	
	FUNCTION getcMoneda (cMoneda)
		RETURN this.cMoneda 
	ENDFUNC
	
	FUNCTION getcCod_pais(nCod_pais)
		RETURN this.nCod_pais 
	ENDFUNC
	
	FUNCTION getcPais(cPais)
		RETURN this.cPais 
	ENDFUNC
	
	*ABSTRACTA 
	FUNCTION getMascara()
	ENDFUNC 

*-------------------------------SET------------------------------------------
	FUNCTION setcPais(cPais)
		this.cPais = cPais
	ENDFUNC
	
	FUNCTION setcCod_pais(cCod_pais)
		this.cCod_pais = cCod_pais
	ENDFUNC
	
	FUNCTION setcMoneda(cMoneda)
		this.cMoneda = cMoneda
	ENDFUNC
	
	FUNCTION setcAcronimoMoneda(cAcronimoMoneda)
		this.cAcronimoMoneda = cAcronimoMoneda
	ENDFUNC
	
	FUNCTION setcMascaraTributaria(cMascaraTributaria)
		this.cMascaraTributaria = cMascaraTributaria
	ENDFUNC
	
	FUNCTION setcSiglaTributaria(cSiglaTributaria)
		this.cSiglaTributaria = cSiglaTributaria
	ENDFUNC


	
ENDDEFINE 
*-------------------------------REGIONALARGENTINA-----------------------------	

DEFINE CLASS RegionalArg as Regional 
	
	
	**En maxirest los tributos se setean en cada cliente o los impuestos internos de los articulos
	**Tributo : 
	
	FUNCTION getTributo()
		LOCAL xmlTributo
		**CONSULTAR TRIBUTOS REFERENCIAS
		CREATE CURSOR Tmp_Tributo (clave c(10),valor n(4))
		INSERT INTO Tmp_Tributo VALUES ("IBBM",0)
		INSERT INTO Tmp_Tributo VALUES ("ARBA",0)
		INSERT INTO Tmp_Tributo VALUES ("Ganancia",0)
		INSERT INTO Tmp_Tributo VALUES ("ABL",0)
		INSERT INTO Tmp_Tributo VALUES ("Impuesto interno",0)
		
		CURSORTOXML("Tmp_Tributo","xmlTributo")
		
		IF USED("Tmp_Tributo")
			USE IN Tmp_Tributo
		ENDIF 
		RETURN xmlTributo
		
	ENDFUNC 
	
	**Impuestos de facturas correspondientes ARGENTINA IVA
	FUNCTION getimpuesto
		LOCAL xmlimpuesto
		CREATE CURSOR Tmp_Impuesto (clave c(10),porcentaje n(4))
		INSERT INTO Tmp_Impuesto  VALUES ("Iva",21)
		INSERT INTO Tmp_Impuesto  VALUES ("Iva",10.5)
		INSERT INTO Tmp_Impuesto  VALUES ("Iva",0)
		CURSORTOXML("Tmp_Impuesto","xmlimpuesto")
		
		IF USED("Tmp_Impuesto")
			USE IN Tmp_Impuesto 
		ENDIF 
		
		RETURN xmlimpuesto 
	ENDFUNC 
	
	**Cursor de comprobantes disponibles para la region,devuelve un XML del mismo
	FUNCTION getComprobante
	
		LOCAL xmlcomprobante
		
		CREATE CURSOR Tmp_Comprobante (codigo c(2),tipo c(20),tipodoc c(30))
		***Facturas Fiscales
		INSERT INTO Tmp_Comprobante  VALUES ("A","Factura A","Fiscal")
		INSERT INTO Tmp_Comprobante  VALUES ("B","Factura B","Fiscal")
		INSERT INTO Tmp_Comprobante  VALUES ("C","Factura C","Fiscal")
		INSERT INTO Tmp_Comprobante  VALUES ("M","Factura M","Fiscal")
		
		**Facturas Electronicas 
		INSERT INTO Tmp_Comprobante VALUES ("A","Factura A","Electronica")
		INSERT INTO Tmp_Comprobante VALUES ("B","Factura B","Electronica")
		INSERT INTO Tmp_Comprobante VALUES ("C","Factura C","Electronica")
		INSERT INTO Tmp_Comprobante VALUES ("M","Factura M","Electronica")
		
		**Nota de Cretio Fiscales
		INSERT INTO Tmp_Comprobante VALUES ("NcA","Nota de Credito A","Fiscal")
		INSERT INTO Tmp_Comprobante VALUES ("NcB","Nota de Credito B","Fiscal")
		INSERT INTO Tmp_Comprobante VALUES ("NcC","Nota de Credito C","Fiscal")
		INSERT INTO Tmp_Comprobante VALUES ("NcM","Nota de Credito M","Fiscal")
		**Nota de Creditos Electronicas
		INSERT INTO Tmp_Comprobante VALUES ("NcA","Nota de Credito A","Electronica")
		INSERT INTO Tmp_Comprobante VALUES ("NcB","Nota de Credito B","Electronica")
		INSERT INTO Tmp_Comprobante VALUES ("NcC","Nota de Credito C","Electronica")
		INSERT INTO Tmp_Comprobante VALUES ("NcM","Nota de Credito M","Electronica")
	
		**Factura no Fiscal / Nota de credito 
		**A-C tambien?
		INSERT INTO Tmp_Comprobante VALUES ("B","Factura B","Otros")
		INSERT INTO Tmp_Comprobante VALUES ("B","Nota de credito B","Otros")
		
		CURSORTOXML("Tmp_Comprobante","xmlcomprobante")
		
		IF USED("Tmp_Comprobante")
			USE IN Tmp_Comprobante
		ENDIF 
		
		RETURN xmlcomprobante 
	ENDFUNC 
	
	**Arma la estructura de la mascara 
	**IMPLEMENTA DE LA CLASE ABSTRACTA 
	FUNCTION getMascara()
		CREATE CURSOR curMascara (letra c(2),ptoVenta n(1),numero n(1))
		INSERT INTO curMascara(letra, ptoVenta, numero) VALUES ("FC", 4, 8)
		CURSORTOXML('curMascara', 'mascaraXml')
	RETURN mascaraXml
	ENDFUNC 
	
ENDDEFINE

*-------------------------------REGIONALAURUGUAY-----------------------------	
DEFINE CLASS RegionalUru as Regional
 
 
	FUNCTION getTributo
		LOCAL xmlTributo,Tmp_Tributo 
		CREATE CURSOR Tmp_Tributo (clave c(10),porcentaje n(4))
		INSERT INTO Tmp_Tributo VALUES ("IMESI",21)
		
		CURSORTOXML("Tmp_Tributo","xmlImpuesto")
		RETURN xmlTributo
	ENDFUNC 
	
	FUNCTION getimpuesto
		LOCAL xmlImpuesto,Tmp_Impuesto 
		
		CREATE CURSOR Tmp_Impuesto(clave c(10),porcentaje n(4))
		INSERT INTO Tmp_Impuesto VALUES ("IRAE",25)
		INSERT INTO Tmp_Impuesto VALUES ("IP",1.5)
		INSERT INTO Tmp_Impuesto VALUES ("IVA",22)
		INSERT INTO Tmp_Impuesto VALUES ("IVA",10)
		
		**Consultar este ya que el mismo se calcula en base sobre la renta del ultimo periodo fiscal 
		INSERT INTO Tmp_Impuesto VALUES ("IRPF",0)
		
		CURSORTOXML("Tmp_Impuesto" ,"xmlimpuesto")
		
		RETURN xmlImpuesto
	ENDFUNC 
*-----------------------------------------------------COMPROBANTESURU-------------------------------------------------------------
**Comprobantes de uruguay
 **https://www.sicfe.com.uy/que-es-la-factura-electronica/


**Referencias:
*!*	e-Factura: 
***comprobante fiscal electrónico utilizado para documentar operaciones con contribuyentes.
*!*	Nota de Crédito y de Débito de e-Factura: 
****comprobantes fiscales electrónicos utilizados para documentar ajustes en relación a operaciones previamente documentadas en e-Facturas.

*!*	e-Ticket: 
***comprobante fiscal electrónico utilizado para documentar operaciones con consumidores finales.
*!*	Nota de Crédito y de Débito de e-Ticket: 
***comprobantes fiscales electrónicos utilizados para documentar ajustes en relación a operaciones previamente documentadas en e-Tickets.

*!*	e-Remito: 
***comprobante fiscal electrónico utilizado para documentar el movimiento físico de bienes.

*!*	e-Resguardo: 
***comprobante fiscal electrónico utilizado para respaldar retenciones y percepciones de impuestos realizadas por los sujetos pasivos responsables.

	
	FUNCTION getComprobante
		LOCAL xmlComprobante,Tmp_Comprobante 
		
			CREATE CURSOR Tmp_Comprobante (codigo c(10),tipo c(40),tipodoc c(30))
			**Factura E-Ticket 
			INSERT INTO Tmp_Comprobante VALUES ("101","e-Ticket","Factura Electronica")
			INSERT INTO Tmp_Comprobante VALUES ("102","Nota de Crédito de e-Ticket","Factura Electronica")
			INSERT INTO Tmp_Comprobante VALUES ("103","Nota de Débito de e-Ticket ","Factura Electronica")
			**e-Facturae
			
			INSERT INTO Tmp_Comprobante VALUES ("111","e-Factura","Factura Electronica")
			INSERT INTO Tmp_Comprobante VALUES ("112","Nota de Crédito de e-Factura","Factura Electronica")
			INSERT INTO Tmp_Comprobante VALUES ("113","Nota de Débito de e-Factura","Factura Electronica")
			**	e-Remito 
			INSERT INTO Tmp_Comprobante VALUES ("181","e-Remito","Factura Electronica")
			**e-Resguardo 
			INSERT INTO Tmp_Comprobante VALUES ("182","e-Resguardo","Factura Electronica")
			
			CURSORTOXML("Tmp_Comprobante","xmlcomprobante")
		
		RETURN xmlComprobante
	ENDFUNC 
	
ENDDEFINE 
*-------------------------------REGIONALAPARAGUAY-----------------------------
**
**Referencias 
*https://ekuatia.set.gov.py/portal/ekuatia/informaciondos
*https://www.set.gov.py/portal/PARAGUAY-SET/detail?content-id=/repository/collaboration/sites/PARAGUAY-SET/documents/facturacion-electronica/Manual%20Tecnico%20Preliminar.pdf#
*Facturas :
*!*	Factura electrónica
*!*	Auto factura electrónica
*!*	Nota de crédito electrónica
*!*	Nota de débito electrónica
*!*	Nota de remisión electrónica

DEFINE CLASS RegionalPar

	**Tributos :
	**IRACIS : . Renta de Actividades Comerciales, Industriales o de Servicios Impuestos
	**Tasas del Impuesto Selectivo al Consumo (ISC) - Parecido a impuestos internos 
	
	FUNCTION getTributo
		LOCAL xmlTributo,Tmp_Tributo 
		CREATE CURSOR Tmp_Tributo (clave c(10),porcentaje n(4))
		INSERT INTO Tmp_Tributo VALUES ("IRACIS",10)
		INSERT INTO Tmp_Tributo VALUES ("ISC",0)
		CURSORTOXML("Tmp_Tributo","xmlImpuesto")
		RETURN xmlTributo
		
		RETURN xmlTributo
	ENDFUNC 
	
	FUNCTION getimpuesto
		LOCAL xmlImpuesto,Tmp_Impuesto 
		
		CREATE CURSOR Tmp_Impuesto (clave c(10),porcentaje n(3))
		INSERT INTO Tmp_Impuesto  VALUES ("Iva",10)
		INSERT INTO Tmp_Impuesto  VALUES ("Iva",12)
		INSERT INTO Tmp_Impuesto  VALUES ("Iva",22)
	
		
		CURSORTOXML("Tmp_Impuesto","xmlImpuesto")
		RETURN xmlImpuesto
	ENDFUNC 
	
	FUNCTION getComprobante
		LOCAL xmlComprobante,Tmp_Comprobante 
		
		CREATE CURSOR Tmp_Comprobante (codigo c(10),tipo c(40),tipodoc c(30))
			**Facturas electrónicas 
			INSERT INTO Tmp_Comprobante VALUES ("1","Factura electrónica","Factura Electronica")
			INSERT INTO Tmp_Comprobante VALUES ("4","Autofactura electrónica","Factura Electronica")
			**Notas de Credito/Debito
			INSERT INTO Tmp_Comprobante VALUES ("5","Nota de crédito electrónica","Factura Electronica")
			INSERT INTO Tmp_Comprobante VALUES ("6","Nota de crédito electrónica","Factura Electronica")
			INSERT INTO Tmp_Comprobante VALUES ("7","Nota de remisión electrónica","Factura Electronica")
			
			
			CURSORTOXML("Tmp_Comprobante","xmlcomprobante")
		
		RETURN xmlComprobante
	ENDFUNC
	
ENDDEFINE 

