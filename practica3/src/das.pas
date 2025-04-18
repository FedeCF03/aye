{Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}

Program ej7;

Const valoralto = 500000;

Type 
  especie = Record
    codigo: integer;
    nombre: string;
    familia: string;
    descripcion: string;
    zona: string;
  End;
  archivo = file Of especie;

  text = file Of text;
Procedure leer_ave(Var r:especie; Var a:archivo)
Begin
  If Not(Eof(a))Then
    Read(a,r)
  Else a.cod := valoralto;

End;
Procedure crear_archivo_eliminar(Var a: archivo)

Var reg: especie;
Begin

  While (reg.codigo<>0) Do
    Begin
      ReadLn(reg.codigo);
      If (reg.codigo<>0)Then
        Begin
          ReadLn(reg.nombre);
          ReadLn(reg.familia);
          ReadLn(reg.descripcion);
          ReadLn(reg.zona);
          Write(a,reg);
        End;
    End;
End;
Procedure marcar_bajas(Var a:archivo; Var b :archivo)

Var aux,reg,act,baja: especie;
Begin
  leer_ave(a,reg);
  While (reg.codigo<>valoralto) Do
    Begin
      Reset(b);
      leer_ave(b,baja);
      While ((baja.codigo<>valoralto) And Not(Eof(b))) Do
        leer_ave(b,baja);
      If (baja.codigo==reg.codigo)Then
        Begin
          baja.codigo := baja.codigo*-1;
          Seek(b,FilePos(a)-1);
          Write(b,baja);
          Seek(a,FilePos(a)-1);
          reg.codigo := reg.codigo*-1;
          Write(a,reg);
        End;
      leer_ave(a,reg);
    End;
End;
Procedure compactado(Var a: archivo; Var b: archivo);

// Variable para almacenar el registro actual que se lee de `a`

Var 
  reg, ult: especie;

  // Variable para almacenar la posición del registro actual en el archivo `a`

Var 
  pos: integer;

  // Variable para contar el número de registros borrados

Var 
  reg_borrados: integer;
  // Inicio del procedimiento
Begin
  // Lee el primer registro del archivo `a` en la variable `reg`
  leer_ave(a, reg);
  // Inicializa el contador de registros borrados a 1
  reg_borrados := 1;
  // Recorre todos los registros del archivo `a`
  While (reg.codigo <> valoralto) Do
    Begin
      // Verifica si el registro actual está marcado como eliminado (código negativo)
      If (reg.codigo < 0) Then
        Begin
          // Guarda la posición actual del archivo en la variable `pos`
          pos := FilePos - 1;
          // Busca el último registro en el archivo, teniendo en cuenta los registros borrados
          Seek(a, FileSize(a) - reg_borrados);
          Read(a, ult);
          // Vuelve a la posición del registro actual
          Seek(a, pos);
          // Escribe el último registro en la posición del registro actual
          Write(a, ult);
          // Incrementa el contador de registros borrados
          reg_borrados := reg_borrados + 1;
        End;
      // Lee el siguiente registro del archivo `a` en la variable `reg`
      leer_ave
    End;
  Seek(a,reg_borrados);
  Truncate(a);
  close(a);
End;
