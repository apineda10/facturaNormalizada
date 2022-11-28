*Para probar: 
* Set procedure to mxfactura additive  
* llamar a la funcion getcursoresmxfactura 
* insertarle los datos necesarios  
* covertirlos en xml  
* instacianciar factura con esos xml en el constructor  (CURSORTOXML(NOMBRE_CURSOR,NOMBRE_VARIABLE ))


DEFINE CLASS Factura as mxsession 
	nid_cpb_venta = 0 && id de la tabla donde se guarda el comprobante, se debería llenar cuando se graba 
	
	&& código único del comprobante, se genera al instanciar un objeto de ésta clase
	cCod_comprobante_venta = "" 
	
	&& código único de la venta que puede tener más de un comprobante adentro, para el caso de pos androd lo genera la app y es único
	&& luego lo sube a MRO, para maxirest, Ésta clase debe recibirlo en el init (<<REV>> generarlo con codCtv+Mesa o Pedido+ nuevo numerador de ventas?)
	cCod_venta = ""

	&& código único del maestro de comprobantes, para maxirest cod_cpb
	cCod_comprobante = ""
	
	&& fecha de la factura
	cFecha_hora = ""
	&& fecha fiscal de la factura
	cFecha_hora_fiscal = ""
	
	&& terminal que genera la factura
	nCod_terminal = 0
	cCod_moneda = ""
	
	&& XML con los datos del cliente asociado a la factura
	curCliente = ""
	
	
	&& XML con los datos de todos los items de kla facctura
	curItem_venta = ""
	
	&& XML con los datos de los cobros de la factura
	curCobro = ""
	
	&& XML con los datos de los tributos aplicados a los items de la factura
	curTributo_venta=""
	
	&& XML con los datos de los impuestos aplicados a los items de la factura
	curImpuesto_venta=""

	&& XML con los datos de los descuentos aplicados a la factura y a los items de la factura
	&& <<REV>> ver tema nulleable del codItemVenta en cursor descuento
	curDescuento_venta=""
	
	&& XML con los datos de facturación electrónica (sólo si aplica)
	curFactura_elec=""
	
	&& XML con los datos del comprobante afectado por la venta (ej, si es una nc, a qué factura anula)(sólo si aplica)
	curComprobante_venta_aplicacion="" 
	
	
	FUNCTION init(tcCodVenta,tcCod_comprobante, tcCod_moneda,tcCurItem_venta,tcCurCliente)
		*	TRY 
				this.setEstructuraCursores() && crea los cursores necesarios para validar estructuras
				this.cCod_venta = tcCodVenta
				this.cCod_comprobante_venta = this.getNewCodComprobanteVenta() && genera el código único de comprobante venta
				this.cCod_comprobante = tcCod_comprobante	&& cod_cpb	
				this.cCod_moneda = tcCod_moneda	&& moneda a utilizar

				this.setCurItem_venta(tcCurItem_venta)  							

				this.setCurCliente(tcCurCliente)
			
			*CATCH TO loError
				*THROW this.setlog(" Error, creando factura : " + getErrorMessage(loError))
		*	ENDTRY
		ENDFUNC 
	
	
	HIDDEN FUNCTION getNewCodComprobanteVenta()
		LOCAL lcCod
		lcCod = ""		
		* Aplicar lógica necesaria para obtener un código único de comprobante
		* cómo se genera al instanciar podría haber saltos en la numeración, para facturas que no se guardaron por x motivo
		* no sería problema ya que es un id lógico propio y no un numerador por sí mismo
		* <<REV>> podría incluir un prefijo con el codprd de maxi "MRSQL" (MRSQL4545111)
	RETURN lcCod
	
	*******GETTERS*******
	
	
	FUNCTION getid_cpb_venta()
		RETURN this.nid_cpb_venta
	ENDFUNC 
	
	FUNCTION getCod_comprobante_venta()
		RETURN this.cCod_comprobante_venta
	ENDFUNC
	

	FUNCTION getFecha_hora()
		RETURN this.Fecha_hora
	ENDFUNC		
	
	FUNCTION getFecha_hora_fiscal()
		RETURN this.cFecha_hora_fiscal
	ENDFUNC		
	
	FUNCTION getCod_terminal()
		RETURN this.nCod_terminal
	ENDFUNC	
	
	FUNCTION getCod_moneda()
		RETURN this.cCod_moneda
	ENDFUNC		
		 
	*******GETTERS XML********  
	
	FUNCTION getCurCobro()
		RETURN this.curCobro
	endfunc	
	FUNCTION getCurItem_venta()
		RETURN this.curItem_venta
	endfunc	
	FUNCTION getCurTributo_venta()
		RETURN this.curTributo_venta
	endfunc	
	FUNCTION getCurImpuesto_venta()
		RETURN this.curImpuesto_venta
	endfunc	
	FUNCTION getCurDescuento_venta()
		RETURN this.curDescuento_venta
	endfunc	
	FUNCTION getCurFactura_elec()
		RETURN this.curFactura_elec
	endfunc	
	FUNCTION getCurComprobante_venta_aplicacion()
		RETURN this.curComprobante_venta_aplicacion
	endfunc	
	FUNCTION getCurCliente 	
		RETURN this.curCurCliente 
	endfunc	
		
	
	*****SETTERS*********
	FUNCTION setid_cpb_venta(tnid_cpb_venta)
		this.nid_cpb_venta=tnid_cpb_venta
	ENDFUNC 
	
	FUNCTION setCod_comprobante_venta(tcCod_comprobante_venta)
		this.cCod_comprobante_venta=tcCod_comprobante_venta
	ENDFUNC
	
	
	FUNCTION setFecha_hora(tcFecha_hora)
		this.Fecha_hora=tcFecha_hora
	ENDFUNC		
	
	FUNCTION setFecha_hora_fiscal(tcFecha_hora_fiscal)
		this.cFecha_hora_fiscal=tcFecha_hora_fiscal
	ENDFUNC		
	
	FUNCTION setCod_terminal(tnCod_terminal)
		this.nCod_terminal=tnCod_terminal
	ENDFUNC	
	
	FUNCTION setCod_moneda(tcCod_moneda)
		this.cCod_moneda=tcCod_moneda
	ENDFUNC		
		
	*****SETTER CURSORES***** 
	FUNCTION setCurCobro(tcXmlCobro)
		TRY 
			IF this.validarEstructuraCobro(tcXmlCobro)
				this.curCobro=tcXmlCobro
			ELSE 
				THROW " Error, los datos de cobros no son válidos : "
			ENDIF 
		CATCH TO loError
			THROW this.setlog(" Error, seteando datos de cobros : " + getErrorMessage(loError))
		ENDTRY 
	endfunc		
		
	FUNCTION setCurItem_venta(tcXmlItem_venta)
		TRY 
			this.validarEstructuraItem_venta(tcXmlItem_venta)
			this.curItem_venta=tcXmlItem_venta	
			
		CATCH TO loError
			THROW this.setlog(" Error, seteando datos de items en factura : " + getErrorMessage(loError))
		ENDTRY
	ENDFUNC 	
	
	FUNCTION setCurTributo_venta(tcXmlTributo_venta)
		TRY 
			this.validarEstructuraTributo_venta(tcXmlTributo_venta)
			this.curTributo_venta=tcXmlTributo_venta 
		CATCH TO loError
			THROW this.setlog(" Error, seteando datos de tributos en factura : " + getErrorMessage(loError))
		ENDTRY 	
	endfunc	
	
	FUNCTION setCurImpuesto_venta(tcXmlImpuesto_venta)
		TRY 
			this.validarEstructuraImpuesto_venta(tcXmlImpuesto_venta)
			this.curImpuesto_venta=tcXmlImpuesto_venta			 
		CATCH TO loError
			THROW this.setlog(" Error, seteando datos de impuestos en factura : " + getErrorMessage(loError))
		ENDTRY 
	endfunc	
	
	FUNCTION setCurDescuento_venta(tcXmlDescuento_venta)
		TRY 
			this.validarEstructuraDescuento_venta(tcXmlDescuento_venta)
			this.curDescuento_venta=tcXmlDescuento_venta			 
		CATCH TO loError
			THROW this.setlog(" Error, seteando datos de descuento en factura : " + getErrorMessage(loError))
		ENDTRY		
	endfunc	
	
	FUNCTION setCurFactura_elec(tcXmlFactura_elec)
		TRY 
			this.validarEstructuraFactura_elec(tcXmlFactura_elec)
			this.curFactura_elec=tcXmlFactura_elec
			 
		CATCH TO loError
			THROW this.setlog(" Error, seteando datos de factura electronica en factura : " + getErrorMessage(loError))
		ENDTRY			
		
	endfunc	
	
	FUNCTION setCurComprobante_venta_aplicacion(tcXmlCpb_venta_aplicacion)
		this.curComprobante_venta_aplicacion=xmlComprobante_venta_aplicacion
		TRY 
			this.validarEstructuraCpb_venta_aplicacion(tcXmlCpb_venta_aplicacion)
			this.curComprobante_venta_aplicacion=tcXmlCpb_venta_aplicacion
			 
		CATCH TO loError
			THROW this.setlog(" Error, seteando datos de venta aplicacion en factura : " + getErrorMessage(loError))
		ENDTRY			
		
	endfunc		
	
	FUNCTION setCurCliente(tcXmlCurCliente)
		TRY 
			this.validarEstructuraCliente(tcXmlCurCliente)
			this.curCliente = tcXmlCurCliente			 
		CATCH TO loError
			THROW this.setlog(" Error, seteando datos de cliente en factura : " + getErrorMessage(loError))
		ENDTRY			
		
	endfunc		
	
	*****VALIDADORES DE ESTRUCTURAS******
	HIDDEN FUNCTION validarEstructuraCobro(tcXmlCobro)
		LOCAL llret
		* obtener xml de this.curCobro y comprarlo con tcXmlCobro
		* el comparador de cursores xml estaría afuera y sería genérico lo que haría
		* sería llevar a cursor los xml, comparar estructuras con structocursor y .t. si son campatibles o .f. 
		* caso contrario. cerrar los cursores.
		llret = .t.
	RETURN llret
	
	HIDDEN FUNCTION validarEstructuraItem_venta(tcXmlItem_venta) 
	LOCAL llret
		llret = .t.
		* analizar la estructura y si es inválida lanzar una excepción indicando motivo
	RETURN llret
	
	HIDDEN FUNCTION validarEstructuraImpuesto_venta(tcXmlImpuesto_venta)
	LOCAL llret
		llret = .t.
		* analizar la estructura y si es inválida lanzar una excepción indicando motivo
	RETURN llret

	HIDDEN FUNCTION validarEstructuraDescuento_venta(tcXmlDescuento_venta)
	LOCAL llret
		llret = .t.
		* analizar la estructura y si es inválida lanzar una excepción indicando motivo
	RETURN llret	
	
	
	HIDDEN FUNCTION validarEstructuraFactura_elec(tcXmlFactura_elec)
	LOCAL llret
		llret = .t.
		* analizar la estructura y si es inválida lanzar una excepción indicando motivo
	RETURN llret	
	
	
	HIDDEN FUNCTION validarEstructuraCpb_venta_aplicacion(tcXmlCpb_aplicacion)
	LOCAL llret
		llret = .t.
		* analizar la estructura y si es inválida lanzar una excepción indicando motivo
	RETURN llret	
	
	
	HIDDEN FUNCTION validarEstructuraCliente(tcXmlCurCliente)
	LOCAL llret 
		llret = .t.
		* analizar la estructura y si es inválida lanzar una excepción indicando motivo
	RETURN llret
	
	HIDDEN FUNCTION validarEstructuraTributo_venta(tcXmlTributo_venta)
	LOCAL llret 
		llret = .t.
		* analizar la estructura y si es inválida lanzar una excepción indicando motivo
	RETURN llret
	
	
	
	****SET INICIAL*****
	FUNCTION setEstructuraCursores() 

		this.curItem_venta = this.genXmlCurItem_venta()
		this.curCobro=this.genXMLCurCobro()
		this.curTributo_venta = this.genXmlTributo_venta()
		this.curImpuesto_venta = this.genXmlImpuesto_venta()
		this.curDescuento_venta = this.genXmlDescuento_venta()
		this.curFactura_elec = this.genXmlFactura_elec()
		this.curComprobante_venta_aplicacion = this.genXmlComprobante_venta_aplicacion() 
 		
	ENDFUNC 
	
	**** GENERADORES DE ESTRUCTURA INICIAL ***********
	HIDDEN FUNCTION genXMLCurCobro()
		LOCAL lcCur
		CREATE CURSOR Cobro (id_cobro n(8),cod_cobro c(40), cod_comprobante_venta c(40),cod_movimiento n(8);
			,cod_medio_pago c(1), importe n(10,2), fecha_hora c(50),cod_terminal n(10),; 
			cod_moneda_cotizacion c(40),cod_tipo_movimiento c(10)) 		
		CURSORTOXML("cobro","lccur")		
		IF USED('Cobro')
			USE IN Cobro
		ENDIF 	
		RETURN lccur
	
	ENDFUNC 
	
	HIDDEN FUNCTION genXmlCurItem_venta 
		LOCAL lccur 
		CREATE CURSOR item_venta (id_item_venta n(8),cod_item_venta n(8),cod_comprobante_venta c(40);
		,cod_producto n(8), detalle_producto c(60),precio_unitario n(10,2), cantidad n(10),cod_receta n(8))
		
		CURSORTOXML("item_venta","lccur")
		
		IF USED('item_venta ')
			USE IN Cobro
		ENDIF 	
		RETURN lccur
	ENDFUNC 
	
	HIDDEN FUNCTION genXmlTributo_venta()
	LOCAL lccur 
		CREATE CURSOR tributo_venta (id_tributo_venta n(8), cod_tributo_venta c(40);
			,cod_item_venta n(8),cod_comprobante_venta c(40),cod_tributo n(2),base_calculo n(10,2), porcentaje n(10,2), importe n(10,2))
		
		CURSORTOXML("tributo_venta","lccur")		
		IF USED('tributo_venta ')
			USE IN tributo_venta 
		ENDIF 	
		RETURN lccur
	ENDFUNC 
	
	
	HIDDEN FUNCTION genXmlImpuesto_venta()
	LOCAL lccur
		CREATE CURSOR Impuesto_venta (id_impuesto_venta n(8),cod_impuesto_venta c(40);
			,cod_comprobante_venta c(40) ,cod_impuesto n(8), base_calculo n(10,2),porcentaje n(10,2), importe n(10,2), cod_item_venta c(40))		
		CURSORTOXML("Impuesto_venta" ,"lccur")
		
		IF USED('Impuesto_venta')
			USE IN Impuesto_venta 
		ENDIF 	
		RETURN lccur
	ENDFUNC 
	
	HIDDEN FUNCTION genXmlDescuento_venta()
	LOCAL lccur
	
	******REVISAR!!!!*************
		CREATE CURSOR Descuento_venta(id_descuento_venta n(8), cod_descuento_venta c(40), cod_comprobante_venta c(40), cod_descuento n(8);
			,base_calculo n(10,2),formula c(1),valor n(10,2) , Descuento_venta_item  c(100))
			
		CURSORTOXML("Descuento_venta","lccur")
		
		IF USED('Descuento_venta')
			USE IN Descuento_venta
		ENDIF 	
		RETURN lccur	
	ENDFUNC 
	
	HIDDEN FUNCTION genXmlFactura_elec()
		CREATE CURSOR Factura_elec(id_factura_elec n(8),cod_factura_elec c(40),cod_comprobante_venta c(40), resultado c(50);
			,reproceso c(100),cae n(20),cae_fecha_vto d, cod_terminal n(10),cod_moneda c(10))
		
		CURSORTOXML("Factura_elec","lccur")
		
		IF USED('Factura_elec')
			USE IN Factura_elec
		ENDIF 	
		RETURN lccur	
		
	ENDFUNC 
	
	HIDDEN FUNCTION genXmlComprobante_venta_aplicacion()
		CREATE CURSOR Comprobante_venta_aplicacion(id_comprobante_venta_aplicacion n(8),cod_comprobante_venta c(40), cod_nota_credito n(8)) 
		CURSORTOXML("Comprobante_venta_aplicacion","lccur")
		
		IF USED('Comprobante_venta_aplicacion')
			USE IN Comprobante_venta_aplicacion
		ENDIF 	
		RETURN lccur	
			
	ENDFUNC 
				
	HIDDEN FUNCTION genXmlCurCliente()
		CREATE CURSOR Cliente (id_cliente_venta n(8), cod_comprobante_venta c(40), cli_codigo n(8), cli_nombre c(50), cli_apellido c(50), cli_razon_s c(70);
			, cli_identificacion n(16), cli_calle c(100), cli_altura c(10), cli_pisodepto c(20), cli_codPostal c(16), cli_provincia c(30);
			, cli_email c(80), cli_tipoiva c(2), idTributario c(40), cli_codidentificacion n(3)) 
		CURSORTOXML("Cliente","lccur")
		
		IF USED('Cliente')
			USE IN Cliente 
		ENDIF 	
		RETURN lccur			
	ENDFUNC 							
ENDDEFINE 