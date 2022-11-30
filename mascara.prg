*------------------------------------------------------------------------------------*
*									     CLASE MASCARA
*------------------------------------------------------------------------------------*

DEFINE CLASS Mascara as session &&mxsession

*--------------------------------GET MASCARA------------------------------------------
	FUNCTION getMascara (comprobante as Comrpobante, regionalArg as Regional)
		LOCAL cLetra, nPtoVenta, nNumero, xmlMascara, curMascara, loError, cMascara 
		
		TRY 
			cLetra = comprobante.getLetra()
			nPtoVenta = comprobante.getPtoVenta()
			nNumero = comprobante.getNumero()
			
			xmlMascara = regionalArg.getMascara()
			XMLTOCURSOR(xmlMascara, "curMascara")
			
			cMascara = ALLTRIM(curMascara.Letra+ cLetra+ "-" + padl(nPtoVenta,curMascara.PtoVenta,"0") + "-" + padl(nNumero,curMascara.Numero,"0"))
		
		CATCH TO loError
			this.setLog(loError.message)
		ENDTRY 
	RETURN cMascara
	ENDFUNC 

*-----------------------------------GET DETALLE------------------------------------
	FUNCTION getDetalle(tcMascara as String)
		LOCAL cDetalle
		cDetalle = STRTRAN(tcMascara, "-", "|")
		RETURN cDetalle
	ENDFUNC 
*-----------------------------------GET VALOR------------------------------------------
	FUNCTION getValor()
	LOCAL cValor, nContador, cValor
		
		xmlMascara = regionalArg.getMascara()
		XMLTOCURSOR(xmlMascara, "curMascara")
		
		SELECT curMascara
		nContador = 0
		cValor = ""
		
		SCAN
			cValor = ALLTRIM(FIELD(contador + 1) + "|" + cValor)
		ENDSCAN
		
	RETURN cValor
	ENDFUNC 

ENDDEFINE



