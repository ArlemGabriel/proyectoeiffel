deferred class
	COLUMNA

feature -- Access
	get_nombre : STRING
		do Result :=nombrecolumna end
	get_tipo : STRING
		do Result :=tipo end
	get_noreplicado : BOOLEAN
		do Result :=nohayreplicados end
	get_tamano: INTEGER
		deferred end


feature -- Basic operations
	nohaydatosreplicados
		deferred
		ensure
			nohayreplicados/=old nohayreplicados
		end

	agregardatos(nuevodato :STRING)
		deferred
		end

	verificardatos(nuevodato :STRING):BOOLEAN
		deferred
		end

	obtenerdatosdefilas(indice: INTEGER) :STRING
		deferred
		end

	borrardatos(indice: INTEGER)
		deferred
		end

	verificarcondicion(operador,condicion:STRING; conteofilas:INTEGER):BOOLEAN
		deferred
		end

feature {NONE} -- Implementation
	nombrecolumna: STRING
	tipo: STRING
	nohayreplicados:BOOLEAN
end
