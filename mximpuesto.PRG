DEFINE CLASS Impuesto as mxsession 

	nCodigo=0
	cNombre=''
	nPorcentaje=0.00
	
	FUNCTION calcular(toFactura) 
		TRY 
		SET STEP ON
			IF TYPE("toFactura")="O"
			*obtengo los items a facturar
				XMLTOCURSOR(toFactura.curItem_venta(),"tmp_ItemVenta")
				IF USED('tmp_ItemVenta')
				SET STEP ON
					this.aplicarImpuestos(toFactura) 					
					USE IN tmp_ItemVenta
				ELSE
					THROW "No se puede acceder a los items para aplicar el calculo de impuesto" 
				ENDIF 
			ELSE
				THROW " Error validando al Objeto Factura : "	 
			ENDIF 
		CATCH TO loError 
			 this.setlog(" Error aplicando impuestos en objeto factura: " + getErrorMessage(loError))	
		ENDTRY 
	ENDFUNC 
	
	HIDDEN FUNCTION aplicarImpuestos(toFactura)
	*Se redifine en subclase		
	ENDFUNC  
	
	HIDDEN FUNCTION getPorcentaje(tnCodArt)
	*Se redifine en subclase
	ENDFUNC 
	
	HIDDEN FUNCTION getPorcentajeIva(toFactura, tnCodArt)
	*Se redifine en subclase
	ENDFUNC 
	
	HIDDEN FUNCTION getCodImpuestoUnico()
	* Esto devuelve un codigo unico de tributo para cada registro de tributo venta <<REV>>
	* Definir logica de impuesto unico
	return "Imp_"+ SYS(3)
	
	HIDDEN FUNCTION genCursorToInsert(tcNombre)
		CREATE CURSOR tcNombre (id_impuesto_venta n(8),cod_impuesto_venta c(40);
		,cod_comprobante_venta c(40) ,cod_impuesto n(8), base_calculo n(10,2),porcentaje n(10,2), importe n(10,2), cod_item_venta c(40))
	ENDFUNC 
ENDDEFINE 

DEFINE CLASS ImpuestoARG as Impuesto

	FUNCTION aplicarImpuestos(toFactura)
		LOCAL lnporcImp_int, lnBase ,lnimporte ,lnporciva 
		lnporcImp_int=0
		lnBase=0
		lnimporte=0
		lnporciva=0
		TRY 
			*obtengo el cursor de impuestos
			*XMLTOCURSOR(toFactura.getCurImpuesto_venta(), "tmp_impuesto")
			this.genCursorToInsert("tmp_impuesto")
			IF USED("tmp_impuesto")		
		
				SELECT tmp_ItemVenta
				LOCATE
				SCAN
					*por cada item, obtenemos el porcentaje seteado como impuesto interno 
					lnporcImp_int=this.getporcentaje(tmp_ItemVenta.cod_item_venta)
					IF !EMPTY(lnporcImp_int)
						*en caso de que impuesto interno sea distinto de 0,
						*obtenemos porcentaje de iva declarado en cursor tributo 
						*y calculamos importe de impuesto interno e insertamos en cursor impuesto
						lnporciva = this.getPorcentajeIva(toFactura, tmp_ItemVenta.cod_item_venta)
						lnimporte = CalcImpInterno(tmp_ItemVenta.precio_unitario, lnporcentaje , lnporciva) * tmp_ItemVenta.cantidad
						lnBase = tmp_ItemVenta.precio_unitario * tmp_ItemVenta.cantidad			
	****<VER> DEBE INSERTAR COD_IMPUESTO E ID_IMPUESTO????
						INSERT INTO tmp_impuesto(cod_impuesto_venta, cod_comprobante_venta;
								 , base_calculo, porcentaje, importe, cod_item_venta);
							VALUES;
								 (this.getCodImpuestoUnico(),tmp_ItemVenta.cod_comprobante_venta;
								 	, lnBase, lnporcImp_int, lnimporte, tmp_ItemVenta.cod_item_venta)
					ENDIF
				ENDSCAN
				
				IF RECCOUNT("tmp_impuesto")>0 
				*si inserto algo previamente , seteara el cursor en objeto factura 
					CURSORTOXML(tmp_impuesto,"lcXmlImpuestos")
					tofactura.setCurImpuesto_venta(lcXmlImpuestos)
				ENDIF 
				
				USE IN tmp_impuesto
			ENDIF 
			
		CATCH TO loError
			 THROW  this.setlog("Error calculando impuestos de objeto factura: " + getErrorMessage(loError))
		ENDTRY  
	ENDFUNC
	
	HIDDEN FUNCTION getPorcentaje(tnCodArt)
	*dado un codigo de articulo devuelve su porcentaje de impuesto interno
		LOCAL lnret 
		lnret=0 
		TEXT TO cadsqlart TEXTMERGE NOSHOW
			SELECT * FROM mxart WHERE codigo='<<tnCodARt>>'  
		ENDTEXT 
		IF runsql(cadsqlart,"tmpart")!=-1
			lnret= tmpart.imp_int
			USE IN tmpart 
		ENDIF 
		RETURN lnret
	ENDFUNC 
	
	HIDDEN FUNCTION getPorcentajeIva(toFactura, tnCodArt)
	*dado una factura y un codigo de articulo devuelve el porcentaje de iva declarado en tributo
		LOCAL lnret
		lnret=0
		XMLTOCURSOR(tofactura.genXmlTributo_venta(),"tmp_tributo") 
		IF USED("tmp_tributo")
			SELECT tmp_tributo
			LOCATE FOR tmp_tributo.cod_item_venta = tnCodArt 
			IF FOUND()
				lnret = tmp_tributo.porcentaje
			ENDIF 
			
			USE IN tmp_tributo
		ENDIF 
		RETURN lnret
	ENDFUNC 
	 
ENDDEFINE 


DEFINE CLASS ImpuestoURU as ImpuestoARG 
* a priori impuestouru tiene el mismo comportamiento que impuestoarg 
ENDDEFINE 

DEFINE CLASS ImpuestoPAR as Impuesto 
ENDDEFINE 
