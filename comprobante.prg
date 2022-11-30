*-------------------------------------------------------------------------------------------*
*							              COMPROBANTE FACTORY
*-------------------------------------------------------------------------------------------*
DEFINE CLASS FactoryComprobante as Custom &&o Session ?

	FUNCTION getComprobante(tcCodigoRegional as String, tcCodigoComprobante as String)
		LOCAL lcClaseComprobante, lcVarComprobante, loError
		
		TRY	
			DO CASE 
				CASE tcCodigoRegional  = "ARG"
					lcClaseComprobante = ALLTRIM("ComprobanteArg" + tcCodigoComprobante)
				CASE tcCodigoRegional  = "PAR"
					lcClaseComprobante = ALLTRIM("ComprobantePar" + tcCodigoComprobante)
				CASE tcCodigoRegional  = "URU"
					lcClaseComprobante = ALLTRIM("ComprobanteUru" + tcCodigoComprobante)
				OTHERWISE 
					THROW "No existe la region" + tcCodigoRegional 
			ENDCASE 
			**tiene que ser una publica
			IF TYPE(lcClaseComprobante) != "O"
				*PUBLIC lcVarComprobante
				lcVarComprobante = NEWOBJECT(lcClaseComprobante,"comprobante.prg")	
			ENDIF 
			
		CATCH TO loError
			this.setLog(loError.message)
		ENDTRY 
	
	RETURN lcVarComprobante
	ENDFUNC 
	
ENDDEFINE 

*-------------------------------------------------------------------------------------------*
*										      COMPROBANTE
*-------------------------------------------------------------------------------------------*

DEFINE CLASS Comprobante as Session

	*FALTA CREAR ESTAS CLASES PARA INSTANCIAR LOS OBJETOS
	oImpresora = ""
	oTributo = "" 	
	oImpuesto = ""   
	oMascara = ""	
	
	cDetalleComprobante = ""
	cCodigo = ""
	cCodigoExterno = ""
	cNombre = ""
		
	FUNCTION INIT()
	   *FALTA DECLARAR LOS OBJETOS IMPRESORA, TRIBUTO, IMPUESTO, MASCARA
	ENDFUNC 

	*-------------------------SETTERS------------------------*
	
	HIDDEN FUNCTION setCodigo (tcCodigo)
		this.cCodigo = tcCodigo
	ENDFUNC 
	
	HIDDEN FUNCTION setCodigoExterno (tcCodigoExterno)
		this.cCodigoExterno = tcCodigoExterno
	ENDFUNC 
	
	HIDDEN FUNCTION setNombre(tcNombre)
		this.cNombre = tcNombre
	ENDFUNC 
	
	FUNCTION setDetalleComprobante(tcDetalleComprobante)
		this.cDetalleComprobante= tcDetalleComprobante
	ENDFUNC 
	
	*-------------------------GETTERS------------------------*
	
	FUNCTION getCodigo()
		RETURN this.cCodigo
	ENDFUNC
	
	FUNCTION getCodigoExterno()
		RETURN this.cCodigoExterno
	ENDFUNC 
	
	FUNCTION getNombre()
		RETURN this.cNombre
	ENDFUNC 
	
	FUNCTION getMascara() 
	LOCAL cMascara
		cMascara = this.oMascara.getMascara(this as Comprobante) && regional as Regional
		this.oFactura.setDetalleVenta(cMascara) &&Setea la propiedad en Factura - Ver si esta el set en mxfactura
		RETURN cMascara
	ENDFUNC
	
	FUNCTION getDescuento() && ??
		RETURN this.oDescuento
	ENDFUNC
	
	FUNCTION getTributo() && ??
		RETURN this.oTributo
	ENDFUNC
	
	FUNCTION getImpuesto() && ??
		RETURN oImpuesto
	ENDFUNC  

	FUNCTION getImpresora()
		RETURN this.oImpresora
	ENDFUNC 
	
	FUNCTION getDetalleComprobante()
		RETURN this.cDetalleComprobante
	ENDFUNC 
	
	FUNCTION getDetalle()
		RETURN this.oMascara.getDetalle(this.getMascara())
	ENDFUNC
	
	FUNCTION getValor()
		RETURN this.oMascara.getValor() &&pasar regional por parametro?
	ENDFUNC 
	
	*-------------------------ABSTRACTAS------------------------*
	HIDDEN FUNCTION imprimir()
	ENDFUNC
	
	HIDDEN FUNCTION grabar()
	ENDFUNC 
	
	FUNCTION facturar()
	ENDFUNC 
	
ENDDEFINE

*-------------------------------------------------------------------------------------------*
*										COMPROBANTE URU
*-------------------------------------------------------------------------------------------*

DEFINE CLASS ComprabanteUru as Comprobante 
	
	cLetra = ""
	cPrefijo = ""
	nNumero = 0
	cCae = ""
	cVtoCae = ""
	
	FUNCTION init()
		DODEFAULT()
	ENDFUNC 
	
	*-------------------------SETTERS------------------------*
	HIDDEN FUNCTION setLetra(tcLetra)
		this.cLetra = tcLetra
	ENDFUNC 
	
	HIDDEN FUNCTION setPrefijo(tcPrefijo)
		this.cPrefijo = tcPrefijo
	ENDFUNC 
	
	HIDDEN FUNCTION setNumero(tnNumero)
		this.nNumero = tnNumero
	ENDFUNC 
	
	HIDDEN FUNCTION setCae(tcCae)
		this.cCae = tcCae
	ENDFUNC 
	
	HIDDEN FUNCTION setVtoCae(tcVtoCae)
		this.cVtoCae = tcVtoCae
	ENDFUNC 
	
	*-------------------------GETTERS------------------------*
	FUNCTION getLetra()
		RETURN this.cLetra
	ENDFUNC 
	
	FUNCTION getPrefijo()
		RETURN this.cPrefijo
	ENDFUNC
	
	FUNCTION getNumero()
		RETURN this.nNumero
	ENDFUNC
	
	FUNCTION getCae()
		RETURN this.cCae
	ENDFUNC
	
	FUNCTION getVtoCae()
		RETURN this.cVtoCae
	ENDFUNC 
	
	*-------------------------ABSTRACTAS------------------------*
	HIDDEN FUNCTION imprimir()
	ENDFUNC
	
	HIDDEN FUNCTION grabar()
	ENDFUNC 
	
	FUNCTION facturar()
	ENDFUNC 

	
ENDDEFINE 

*-------------------------------------------------------------------------------------------*
*										COMPROBANTE ARG
*-------------------------------------------------------------------------------------------*

DEFINE CLASS ComprobanteArg as Comprobante 
	cLetra = ""
	nNumero = 0
	nPtoVenta = 0
	cPrefijo = ""
	cCae = ""
	cVtoCae = ""
	
	FUNCTION init()
		DODEFAULT()
	ENDFUNC 
	
	*-------------------------SETTERS------------------------*
	FUNCTION setLetra(tcLetra)
		this.cLetra = tcLetra
	ENDFUNC 
	
	HIDDEN FUNCTION setPrefijo(tcPrefijo)
		this.cPrefijo = tcPrefijo
	ENDFUNC 
	
	FUNCTION setNumero(tnNumero)
		this.nNumero = tnNumero
	ENDFUNC 
	
	FUNCTION setPtoVenta(tnPtoVenta)
		this.nPtoVenta = tnPtoVenta
	ENDFUNC 
	
	HIDDEN FUNCTION setCae(tcCae)
		this.cCae = tcCae
	ENDFUNC 
	
	HIDDEN FUNCTION setVtoCae(tcVtoCae)
		this.cVtoCae = tcVtoCae
	ENDFUNC 
	
	*-------------------------GETTERS------------------------*
	FUNCTION getLetra()
		RETURN this.cLetra
	ENDFUNC 
	
	FUNCTION getPrefijo()
		RETURN this.cPrefijo
	ENDFUNC
	
	FUNCTION getNumero()
		RETURN this.nNumero
	ENDFUNC
	
	FUNCTION getPtoVenta()
		RETURN this.nPtoVenta
	ENDFUNC
	
	FUNCTION getCae()
		RETURN this.cCae
	ENDFUNC
	
	FUNCTION getVtoCae()
		RETURN this.cVtoCae
	ENDFUNC 
	
	*-------------------------ABSTRACTAS------------------------*
	HIDDEN FUNCTION imprimir()
	ENDFUNC
	
	HIDDEN FUNCTION grabar()
	ENDFUNC 
	
	FUNCTION facturar()
	ENDFUNC 
ENDDEFINE 

*-------------------------------------------------------------------------------------------*
*										COMPROBANTE PAR
*-------------------------------------------------------------------------------------------*

DEFINE CLASS ComprobantePar as Comprobante 

	cLetra = ""
	nNumero = 0
	cLocal = ""
	nPtoVenta = 0
	cTimbrado = ""
	cVtoTimbrado = ""

	FUNCTION init()
		DODEFAULT()
	ENDFUNC 
	
	*-------------------------SETTERS------------------------*
	HIDDEN FUNCTION setLetra(tcLetra)
		this.cLetra = tcLetra
	ENDFUNC 
	
	HIDDEN FUNCTION setNumero(tnNumero)
		this.nNumero = tnNumero
	ENDFUNC 
	
	HIDDEN FUNCTION setLocal(tcLocal)
		this.cLocal = tcLocal
	ENDFUNC
	
	HIDDEN FUNCTION setPtoVenta(tnPtoVenta)
		this.nPtoVenta = tnPtoVenta
	ENDFUNC 
	
	HIDDEN FUNCTION setTimbrado(tcTimbrado)
		this.cTimbrado = tcTimbrado
	ENDFUNC 
	
	HIDDEN FUNCTION setVtoTimbrado(tcVtoTimbrado)
		this.cVtoTimbrado = tcVtoTimbrado
	ENDFUNC 
		
	*-------------------------GETTERS------------------------*
	FUNCTION getLetra ()
		RETURN this.cLetra
	ENDFUNC
	
	FUNCTION getNumero()
		RETURN this.nNumero
	ENDFUNC 
	
	FUNCTION getLocal()
		RETURN this.cLocal
	ENDFUNC 
	
	FUNCTION getPtoVenta()
		RETURN this.nPtoVenta
	ENDFUNC 
	
	FUNCTION getTimbrado()
		RETURN this.cTimbrado
	ENDFUNC
	
	FUNCTION getVtoTimbrado()
		RETURN this.cVtoTimbrado
	ENDFUNC 
	
	*-------------------------ABSTRACTAS------------------------*
	HIDDEN FUNCTION imprimir()
	ENDFUNC
	
	HIDDEN FUNCTION grabar()
	ENDFUNC 
	
	FUNCTION facturar()
	ENDFUNC 
	
ENDDEFINE 

*-------------------------------------------------------------------------------------------*
*										COMPROBANTE ARG A
*-------------------------------------------------------------------------------------------*

*Argentina permite la emision de Fac A, B, C, M, E y T. Actualmente Maxirest maneja solo A y B,
*tanto Electronicas como Fiscales, con sus respectivas notas de credito

DEFINE CLASS ComprobanteArgA as ComprobanteArg

   *FALTA CREAR CLASE VALIDADOR PARA INSTANCIAR EL OBJETO
	oValidador = ""
	
	FUNCTION INIT()
		DODEFAULT()
		*DELCARAR VALIDADOR
	ENDFUNC 
	
	*-------------------------IMPLEMENTAR------------------------*
	HIDDEN FUNCTION imprimir()
		*MEDIANTE EL OBJETO 'IMPRESORA' SE ENCARGA DE IMPRIMIR EN EL FORMATO CORRESPONDIENTE+
		this.oImpresora.imprimir()
	ENDFUNC
	
	HIDDEN FUNCTION grabar()
		*SUBE LA INFO A LA BDD
	ENDFUNC 
	
	FUNCTION facturar()
		*A PARTIR DE UNA FACTURA DADADEBE APLICAR LA MASCARA, TRIBUTOS, DESCUENTOS E IMPUESTOS,
		*VALIDARLOS, IMPRIMIRLOS Y GRABARLOS.
	ENDFUNC 
	
	FUNCTION validar()
		*VALIDA QUE LOS IMPORTES, PERCEPCIONES, DESCUENTOS, ETC. ESTEN CORRECTAMENTE APLICADOS
		this.oValidador.validar()
	ENDFUNC 
	
ENDDEFINE 
