'-----------------------------------------------------------------
'-----                                                       -----
'-----                   P A C  C L O N                      -----
'----                                                        -----
'----             Programado por: Juan Eguia                 -----
'----                                                        -----
'-----------------------------------------------------------------
'----                C O N S T A N T E S                     -----
'-----------------------------------------------------------------
Const grisSuelo = _RGB32(55)
Const paredColor = _RGB32(157, 157, 98)
Const paredColorOsc = _RGB32(128, 128, 82)
Const blanco = _RGB32(211)
Const fluo = _RGB32(166, 249, 200)
Const gris = _RGB32(105, 122, 122)
Const negro = _RGB32(0, 0, 0)
Const grisaceo = _RGB32(128, 133, 144)
Const amarillo = _RGB32(194, 128, 0)
Const amarilloPac = _RGB32(211, 194, 11)
Const verde = _RGB32(0, 205, 28)
Const azulc = _RGB32(6, 205, 222)
Const rojo = _RGB32(255, 55, 0)

Const TILE_X = 40
Const TILE_Y = 40
Const NRO_FILAS = 15
Const NRO_COLUMNAS = 19

Const RES_X = TILE_X * (NRO_COLUMNAS + 1)
Const RES_Y = TILE_Y * (NRO_FILAS + 1)

Const NRO_FANTASMAS = 4
Const VEL_ANIMA_PAC = 14

Const DURACION_DIES = 40
Const DURACION_AZULES = 2800
Const SHOW_PTOS_CDOWN = 250
Const NRO_PTOS_GORDOS = 4

Const PAUSA_WAKAWAKA = 38
Const FPS = 60

'-----------------------------------------------------------------
'----             V A R I A B L E S  (OBJETOS)
'-----------------------------------------------------------------
Type pacman
    x As Integer
    y As Integer
    radio As Integer
    ancho As Integer
    alto As Integer
    velX As Integer
    velY As Integer
    vel As Integer
    sumarAlto As Integer
    sumarAncho As Integer
    pulsada As Integer
    anima As Integer
    diesAnima As Integer
    dies As Integer
    vueltasDies As Integer
End Type

Type fantasma
    x As Integer
    y As Integer
    radio As Integer
    ancho As Integer
    alto As Integer
    velX As Integer
    velY As Integer
    vel As Integer
    tipoF As Integer
    direccion As Integer
    sumarAlto As Integer
    sumarAncho As Integer
    comido As Integer
    idShow As Integer
End Type

Type fruta
    x As Integer
    y As Integer
    radio As Integer
    ancho As Integer
    alto As Integer
    velX As Integer
    velY As Integer
    vel As Integer
    direccion As Integer
    sumarAlto As Integer
    sumarAncho As Integer
    comido As Integer
    idShow As Integer
End Type

Type puntitos
    x As Integer
    y As Integer
    radio As Integer
    alto As Integer
    ancho As Integer
    visible As Integer
End Type

Type showP
    x As Integer
    y As Integer
    ancho As Integer
    alto As Integer
    idImg As Integer
    cDown As Integer
End Type

Type presen
    x As Single
    y As Single
    ancho As Single
    alto As Single
    vel As Single
End Type

Type ptomira
    x As Integer
    y As Integer
End Type

'-----------------------------------------------------------------
'----            D I M  (RESERVAR ESPACIO EN MEMORIA)
'-----------------------------------------------------------------
Dim pacman As pacman
Dim arrayDireccionesPac(4, 4) As Integer

Dim fantasma(NRO_FANTASMAS) As fantasma
Dim arrayPtosClaveX(20) As Integer
Dim arrayPtosClaveY(20) As Integer

Dim fruta As fruta
Dim showP(5) As showP

Dim puntitos(140) As puntitos
Dim ptosGordos(4) As puntitos
Dim arrayEsc(NRO_COLUMNAS, NRO_FILAS) As Integer

Dim presen As presen
Dim pfp As presen
Dim ptomira As ptomira

Dim pacmanImg(8) As Long
Dim fantasmaImg(8) As Long
Dim fantasmaAzulImg(2) As Long
Dim ojosImg(4) As Long
Dim frutaImg(4) As Long
Dim showImg(8) As Long
Dim ptoGordoImg As Long
Dim preparado As Long
Dim pacGameOver As Long
Dim tituloPacJon As Long

Dim a As Integer
Dim b As Integer
Dim c As Integer
Dim tiempoUpdate As Single
Dim fotogramas As Integer
Dim cadencia As Integer
Dim ciclos As Integer

Dim puntos As Long
Dim nivel As Integer
Dim vidas As Integer
Dim extraL As _Bit

Dim record(10) As Long
Dim rnivel(10) As Integer
Dim nombre(10) As String
Dim archivo As String

Dim momento_actual As Integer
Dim nivel_superado As _Bit
Dim game_over As _Bit
Dim exit_Esc As _Bit

Dim contPuntitosComidos As Integer
Dim nro_puntitos As Integer
Dim nro_ptosGordos As Integer

Dim fantasmasAzules As _Bit
Dim duracionAzules As Integer
Dim animaFantasmas As Integer
Dim ptosComeFantasmas As Integer

Dim wakaEnd As Integer

'----------------------- SONIDOS ----------------------
Dim sonido_gameOver As Long
Dim sonido_go As Long
Dim sonido_levelUp As Long
Dim sonido_extralive As Long
Dim sonido_azules As Long
Dim sonido_pacmanDies As Long
Dim sonido_eatingCherry As Long
Dim sonido_eatingGhost As Long
Dim sonido_inicioNivel As Long
Dim sonido_interMision As Long
Dim sonido_sirena As Long
Dim sonido_wakawaka As Long

'----------------------------- Laberinto (escenario) ------------
Data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
Data 9,5,1,1,1,1,1,1,1,9,1,1,1,1,1,1,1,5,9
Data 9,1,9,9,1,9,9,9,1,9,1,9,9,9,1,9,9,1,9

Data 9,1,9,9,1,9,9,9,1,9,1,9,9,9,1,9,9,1,9
Data 9,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,9
Data 9,1,9,9,1,9,1,9,9,9,9,9,1,9,1,9,9,1,9

Data 9,1,1,1,1,9,1,1,1,9,1,1,1,9,1,1,1,1,9
Data 9,9,9,9,1,9,9,9,1,9,1,9,9,9,1,9,9,9,9
Data 9,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,9

Data 9,1,9,9,1,9,1,9,1,9,1,9,1,9,1,9,9,1,9
Data 9,1,9,9,1,9,1,9,1,9,1,9,1,9,1,9,9,1,9
Data 0,1,1,1,1,9,1,1,1,1,1,1,1,9,1,1,1,1,0

Data 9,1,9,9,1,9,1,9,9,9,9,9,1,9,1,9,9,1,9
Data 9,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,9
Data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9

'---------------------------------------------------------------
'
'                   INICIALIZACION GENERAL
'
'---------------------------------------------------------------
Screen _NewImage(RES_X, RES_Y, 32)
_Title " PacClonQB by Juan Eguia "
_ScreenMove _DesktopWidth / 2 - _Width / 2, _DesktopHeight / 2 - _Height / 2

_PrintMode _KeepBackground
'_FullScreen
'_MouseShow
Randomize Timer

Cls , grisSuelo
Color amarillo, grisSuelo
Locate 18, 40
Print " Cargando... "

updatesSonido
updatesGraficos
updatesGenerales

'-------------------------------------------------------------
'                   P R E S E N T A C I O N
'-------------------------------------------------------------
Cls , grisSuelo
ciclos = 0
_SndLoop sonido_interMision

Do
    _Limit fotogramas
    PCopy _Display, 1

    If _KeyDown(13) Then momento_actual = 0

    pacman_fantasmas_presentacion pfp
    pantallaPresentacion ciclos
    mostrar_records record(), rnivel(), nombre(), 25

    ciclos = ciclos + 1
    If ciclos >= VEL_ANIMA_PAC * 2 Then ciclos = 0

    _Display
    PCopy 1, _Display

Loop Until momento_actual = 0

_SndStop sonido_interMision
soniquete 100, 600
ciclos = 0

'-------------------------------------------------------------
'               I N I C I O   D E   N I V E L   x
'-------------------------------------------------------------
Do
    Do
        updatesNivelX

        '-------------------------------------------------------------
        '                   P R E P A R A D O ...
        '-------------------------------------------------------------
        tiempoUpdate = Timer
        _SndPlayCopy sonido_inicioNivel

        Do
            _Limit fotogramas
            PCopy _Display, 1

            dibujaEscenarioLaberinto
            dibujaPuntitos
            sub_dibuja pacman

            For a = 1 To NRO_FANTASMAS
                sub_dibujaFantasmas fantasma(), a
            Next a

            cuadro RES_X / 2 - 150, RES_Y / 2 - 50, 300, 80
            _PutImage (RES_X / 2 - 150, RES_Y / 2 - 50), preparado

            mostrarMarcadores

            If Timer - tiempoUpdate > 4.5 Then momento_actual = 1
            If _KeyDown(8) Then momento_actual = 1

            _Display
            PCopy 1, _Display
        Loop Until momento_actual = 1

        '-------------------------------------------------------------
        '
        '                B U C L E   P R I N C I P A L
        '
        '-------------------------------------------------------------
        Do
            _Limit fotogramas
            PCopy _Display, 1

            dibujaEscenarioLaberinto
            dibujaPuntitos
            dibujaPtosGordos

            If _KeyDown(8) Then Sleep 99
            If _KeyDown(27) Then exit_Esc = -1

            While _MouseInput
                ptomira.x = _MouseX
                ptomira.y = _MouseY
            Wend

            el_pacman
            los_fantasmas
            la_fruta
            mostrarShowPtos

            mostrarMarcadores
            Line (0, TILE_Y * 12)-Step(TILE_X - 1, TILE_Y - 1), grisSuelo, BF

            If puntos > 5000 And Not extraL Then
                vidas = vidas + 1
                extraL = -1
                _SndPlayCopy sonido_extralive
            End If

            If contPuntitosComidos >= nro_puntitos Then
                nivel_superado = -1
            End If

            ciclos = ciclos + 1

            If cadencia > 0 Then cadencia = cadencia - 1
            If ciclos = 32000 Then ciclos = 1

            If nivel_superado Then
                _SndPlayCopy sonido_levelUp
                Sleep 3
            End If

            _Display
            sub_pausaComeFantasmas showP()
            PCopy 1, _Display

        Loop Until vidas < 0 Or nivel_superado Or exit_Esc

        '-----------------------------------------------------------
        '
        '                   G A M E   O V E R
        '
        '-----------------------------------------------------------
        If nivel_superado Then
            nivel = nivel + 1
        Else
            _SndPlayCopy sonido_gameOver
        End If

        ciclos = 0

        '--------------------------------
        Do
            _Limit fotogramas
            PCopy _Display, 1

            dibujaEscenarioLaberinto
            dibujaPuntitos
            dibujaPtosGordos

            If _KeyDown(27) Then exit_Esc = -1

            While _MouseInput
                ptomira.x = _MouseX
                ptomira.y = _MouseY
            Wend

            If _MouseButton(1) Or _MouseButton(2) Then
                If ptomira.x > RES_X / 2 - 200 And ptomira.x < RES_X / 2 + 200 And ptomira.y > 35 And ptomira.y < 65 Then
                    soniquete 100, 800
                    updatesGenerales
                    vidas = 3
                End If
            End If

            mostrarMarcadores

            _PutImage (RES_X / 2 - 200, RES_Y / 2), pacGameOver

            cuadro RES_X / 2 - 200, 35, 400, 32
            Color amarillo
            Locate 4, 32
            Print " Click aqui para jugar otra partida ... "

            If ciclos = 3 Then
                check_records record(), rnivel(), nombre(), archivo
                update_records record(), rnivel(), nombre(), archivo
            End If

            cuadro RES_X / 2 - 250, 110, 500, 230
            mostrar_records record(), rnivel(), nombre(), 9

            ciclos = ciclos + 1

            If cadencia > 0 Then cadencia = cadencia - 1
            If ciclos = 32000 Then ciclos = 100

            _Display
            PCopy 1, _Display

        Loop Until exit_Esc Or nivel_superado Or vidas = 3

    Loop Until exit_Esc

Loop Until exit_Esc

'-----------------------------------------------------------
'                   F I N   P R O G R A M A
'-----------------------------------------------------------
salir
Beep
System

'===========================================================
'
'                   S U B R U T I N A S
'
'-----------------------------------------------------------
Sub dibujaEscenarioLaberinto

    Dim a As Integer
    Dim x As Integer
    Dim y As Integer

    Shared arrayEsc() As Integer

    For y = 1 To NRO_FILAS
        For x = 1 To NRO_COLUMNAS
            If arrayEsc(x, y) = 9 Then
                Line (x * TILE_X + 1, y * TILE_Y + 1)-Step(TILE_X - 2, TILE_Y - 2), paredColor, BF
                Line (x * TILE_X + 3, y * TILE_Y + 3)-Step(TILE_X - 4, TILE_Y - 4), paredColorOsc, BF
            End If
        Next x
    Next y

End Sub

'==================================================================
Sub dibujaPuntitos

    Dim a As Integer
    Dim ancho As Integer
    Dim alto As Integer

    Shared puntitos() As puntitos
    Shared pacman As pacman

    Shared nro_puntitos As Integer
    Shared contPuntitosComidos As Integer
    Shared puntos As Long
    Shared wakaEnd As Integer

    Shared sonido_wakawaka As Long
    Shared sonido_sirena As Long

    '---------------------------------------
    ancho = Int(puntitos(1).ancho / 2)
    alto = Int(puntitos(1).alto / 2)

    For a = 1 To nro_puntitos - NRO_PTOS_GORDOS
        If puntitos(a).visible > 0 Then
            Line (puntitos(a).x - ancho, puntitos(a).y - alto)-Step(ancho * 2, alto * 2), fluo, BF

            If check_colisionPuntitos(puntitos(), pacman, a, 0) Then
                puntitos(a).visible = 0
                contPuntitosComidos = contPuntitosComidos + 1
                puntos = puntos + 10

                If wakaEnd = 0 Then
                    _SndPlayCopy sonido_wakawaka
                    wakaEnd = PAUSA_WAKAWAKA
                End If
            End If
        End If
    Next a

    If wakaEnd > 0 Then wakaEnd = wakaEnd - 1

End Sub

'==================================================================
Sub dibujaPtosGordos

    Dim a As Integer
    Dim ancho As Integer
    Dim alto As Integer
    Dim sx As Integer
    Dim sy As Integer

    Shared ptosGordos() As puntitos
    Shared pacman As pacman

    Shared fantasmasAzules As _Bit
    Shared duracionAzules As Integer
    Shared ptosComeFantasmas As Integer
    Shared nro_puntitos As Integer
    Shared contPuntitosComidos As Integer
    Shared puntos As Long
    Shared nivel As Integer

    Shared ptoGordoImg As Long
    Shared sonido_eatingGhost As Long
    Shared sonido_azules As Long
    Shared sonido_sirena As Long

    '---------------------------------------
    ptosGordos(1).ancho = ptosGordos(1).ancho - 1
    ptosGordos(1).alto = ptosGordos(1).alto - 1

    If ptosGordos(1).alto <= Int(TILE_Y / 2) Then
        ptosGordos(1).alto = Int(TILE_Y)
        ptosGordos(1).ancho = Int(TILE_X)
    End If

    ancho = ptosGordos(1).ancho
    alto = ptosGordos(1).alto
    sx = Int((TILE_X - ancho) / 2)
    sy = Int((TILE_Y - alto) / 2)

    For a = 1 To NRO_PTOS_GORDOS
        If ptosGordos(a).visible > 0 Then
            _PutImage (ptosGordos(a).x + sx, ptosGordos(a).y + sy)-Step(ancho, alto), ptoGordoImg

            If check_colisionPuntitos(ptosGordos(), pacman, a, 3) Then
                ptosGordos(a).visible = 0
                contPuntitosComidos = contPuntitosComidos + 1
                puntos = puntos + 50
                fantasmasAzules = -1
                duracionAzules = DURACION_AZULES - nivel * 400

                If duracionAzules < 800 Then duracionAzules = 800

                _SndPlayCopy sonido_eatingGhost
                _SndLoop sonido_azules
            End If
        End If
    Next a

End Sub

'==================================================================
Sub el_pacman

    Shared pacman As pacman

    sub_leerTeclado pacman

    If pacman.dies > 0 Then
        sub_pacmanDies pacman
    Else
        sub_actualiza pacman
        sub_dibuja pacman
    End If

End Sub

'------------------------------------------------------------
Sub sub_leerTeclado (pacman As pacman)

    If pacman.x >= TILE_X * 2 And pacman.x < TILE_X * NRO_COLUMNAS Then
        If _KeyDown(19200) Then pacman.pulsada = 1
        If _KeyDown(19712) Then pacman.pulsada = 2
        If _KeyDown(18432) Then pacman.pulsada = 3
        If _KeyDown(20480) Then pacman.pulsada = 4
    End If

End Sub

'------------------------------------------------------------
Sub sub_actualiza (pacman As pacman)

    Dim x As Integer
    Dim y As Integer

    Shared arrayDireccionesPac() As Integer

    '-----------------------------------------------------------
    If pacman.x Mod TILE_X = 0 And pacman.y Mod TILE_Y = 0 Then

        x = Int(pacman.x / TILE_X) + arrayDireccionesPac(pacman.pulsada, 1)
        y = Int(pacman.y / TILE_Y) + arrayDireccionesPac(pacman.pulsada, 2)

        If Not check_colisionEscenario(x, y) Then
            pacman.velX = arrayDireccionesPac(pacman.pulsada, 1)
            pacman.velY = arrayDireccionesPac(pacman.pulsada, 2)
            pacman.sumarAncho = arrayDireccionesPac(pacman.pulsada, 3)
            pacman.sumarAlto = arrayDireccionesPac(pacman.pulsada, 4)
        End If

    End If

    x = Int((pacman.x + pacman.velX + pacman.ancho * pacman.sumarAncho) / TILE_X)
    y = Int((pacman.y + pacman.velY + pacman.alto * pacman.sumarAlto) / TILE_Y)

    If Not check_colisionEscenario(x, y) Then
        pacman.x = pacman.x + pacman.velX * pacman.vel
        pacman.y = pacman.y + pacman.velY * pacman.vel

        ' *** ESCAPATORIAS ***
        If pacman.x > (NRO_COLUMNAS + 1) * TILE_X And pacman.velX > 0 Then pacman.x = 0
        If pacman.x < 0 And pacman.velX < 0 Then pacman.x = (NRO_COLUMNAS + 1) * TILE_X
    End If

End Sub

'------------------------------------------------------------
Sub sub_dibuja (pacman As pacman)

    Dim png As Integer

    Shared pacmanImg() As Long

    '----------------------
    Select Case pacman.velX
        Case -1
            png = 3

        Case 1
            png = 1
    End Select

    Select Case pacman.velY
        Case -1
            png = 5

        Case 1
            png = 7
    End Select

    If pacman.anima < VEL_ANIMA_PAC / 2 Then png = png + 1

    _PutImage (pacman.x, pacman.y)-Step(pacman.ancho, pacman.alto), pacmanImg(png)

    pacman.anima = pacman.anima + 1
    If pacman.anima >= VEL_ANIMA_PAC Then pacman.anima = 0

End Sub

'------------------------------------------------------------
Sub sub_dibujaSinG (pacman As pacman)

    Dim cx As Integer
    Dim cy As Integer

    cx = Int(TILE_X / 2)
    cy = Int(TILE_Y / 2)

    Circle (pacman.x + cx, pacman.y + cy), pacman.radio, amarilloPac
    Paint (pacman.x + cx, pacman.y + cy), amarilloPac, amarilloPac

    pacman.anima = pacman.anima + 1
    If pacman.anima >= VEL_ANIMA_PAC Then pacman.anima = 0

    Select Case pacman.velX
        Case -1
            sub_dibujaIzquierda pacman, cx, cy

        Case 1
            sub_dibujaDerecha pacman, cx, cy
    End Select

    Select Case pacman.velY
        Case -1
            sub_dibujaArriba pacman, cx, cy

        Case 1
            sub_dibujaAbajo pacman, cx, cy
    End Select

End Sub

'------------------------------------------------------------
Sub sub_dibujaDerecha (pacman As pacman, cx As Integer, cy As Integer)

    If pacman.anima < VEL_ANIMA_PAC / 2 Then
        Line (pacman.x + cx, pacman.y + cy)-Step(cx, -Int(cy / 2)), grisSuelo
        Line -Step(0, cy), grisSuelo
        Line -Step(-cx, -Int(cy / 2)), grisSuelo
    Else
        Line (pacman.x + cx, pacman.y + cy)-Step(cx, -cy), grisSuelo
        Line -Step(0, cy * 2), grisSuelo
        Line -Step(-cx, -cy), grisSuelo
    End If

    Paint (pacman.x + cx + 5, pacman.y + cy), grisSuelo, grisSuelo

End Sub

'------------------------------------------------------------
Sub sub_dibujaIzquierda (pacman As pacman, cx As Integer, cy As Integer)

    If pacman.anima < VEL_ANIMA_PAC / 2 Then
        Line (pacman.x + cx, pacman.y + cy)-Step(-cx, -Int(cy / 2)), grisSuelo
        Line -Step(0, cy), grisSuelo
        Line -Step(cx, -Int(cy / 2)), grisSuelo
    Else
        Line (pacman.x + cx, pacman.y + cy)-Step(-cx, -cy), grisSuelo
        Line -Step(0, cy * 2), grisSuelo
        Line -Step(cx, -cy), grisSuelo
    End If

    Paint (pacman.x + cx - 5, pacman.y + cy), grisSuelo, grisSuelo

End Sub

'------------------------------------------------------------
Sub sub_dibujaArriba (pacman As pacman, cx As Integer, cy As Integer)

    If pacman.anima < VEL_ANIMA_PAC / 2 Then
        Line (pacman.x + cx, pacman.y + cy)-Step(-Int(cx / 2), -cy), grisSuelo
        Line -Step(cx, 0), grisSuelo
        Line -Step(-Int(cx / 2), cy), grisSuelo
    Else
        Line (pacman.x + cx, pacman.y + cy)-Step(-cx, -cy), grisSuelo
        Line -Step(cx * 2, 0), grisSuelo
        Line -Step(-cx, cy), grisSuelo
    End If

    Paint (pacman.x + cx, pacman.y + cy - 5), grisSuelo, grisSuelo

End Sub

'------------------------------------------------------------
Sub sub_dibujaAbajo (pacman As pacman, cx As Integer, cy As Integer)

    If pacman.anima < VEL_ANIMA_PAC / 2 Then
        Line (pacman.x + cx, pacman.y + cy)-Step(-Int(cx / 2), cy), grisSuelo
        Line -Step(cx, 0), grisSuelo
        Line -Step(-Int(cx / 2), -cy), grisSuelo
    Else
        Line (pacman.x + cx, pacman.y + cy)-Step(-cx, cy), grisSuelo
        Line -Step(cx * 2, 0), grisSuelo
        Line -Step(-cx, -cy), grisSuelo
    End If

    Paint (pacman.x + cx, pacman.y + cy + 5), grisSuelo, grisSuelo

End Sub

'------------------------------------------------------------
Sub sub_pacmanDies (pacman As pacman)

    Shared fantasma() As fantasma

    Shared vidas As Integer
    Shared fantasmasAzules As _Bit
    Shared animaFantasmas As Integer
    Shared ptosComeFantasmas As Integer

    Shared pacmanImg() As Long

    '-------------------------------------------------
    If pacman.diesAnima < Int(DURACION_DIES / 4) Then
        _PutImage (pacman.x, pacman.y)-Step(pacman.ancho, pacman.alto), pacmanImg(1)
    ElseIf pacman.diesAnima < Int(DURACION_DIES / 4) * 2 Then
        _PutImage (pacman.x, pacman.y)-Step(pacman.ancho, pacman.alto), pacmanImg(7)
    ElseIf pacman.diesAnima < Int(DURACION_DIES / 4) * 3 Then
        _PutImage (pacman.x, pacman.y)-Step(pacman.ancho, pacman.alto), pacmanImg(3)
    Else
        _PutImage (pacman.x, pacman.y)-Step(pacman.ancho, pacman.alto), pacmanImg(5)
    End If

    pacman.diesAnima = pacman.diesAnima + 1

    If pacman.diesAnima >= DURACION_DIES Then
        pacman.diesAnima = 0
        pacman.vueltasDies = pacman.vueltasDies + 1
    End If

    If pacman.vueltasDies >= 4 Then
        vidas = vidas - 1
        pacman.dies = 0
        fantasmasAzules = 0
        animaFantasmas = 0
        ptosComeFantasmas = 100

        sub_updatePacmanNivelX pacman
        sub_updatesFantasmasNivelX fantasma()
    End If

End Sub

'==================================================================
Sub los_fantasmas

    Dim a As Integer
    Dim ptosClave As Integer

    Dim x As Integer
    Dim y As Integer
    Dim pcx As Integer
    Dim pcy As Integer
    Dim perseguir As Integer

    Shared fantasma() As fantasma
    Shared pacman As pacman
    Shared arrayPtosClaveX() As Integer
    Shared arrayPtosClaveY() As Integer

    Shared puntos As Long
    Shared nivel As Integer
    Shared ptosComeFantasmas As Integer
    Shared fantasmasAzules As _Bit

    Shared sonido_pacmanDies As Long
    Shared sonido_eatingGhost As Long

    '-----------------------------------
    For a = 1 To NRO_FANTASMAS

        For ptosClave = 1 To 20

            x = fantasma(a).x
            y = fantasma(a).y
            pcx = arrayPtosClaveX(ptosClave) * TILE_X
            pcy = arrayPtosClaveY(ptosClave) * TILE_Y

            If x = pcx And y = pcy Then
                perseguir = Int(Rnd * 10)

                If perseguir < 7 + nivel Then
                    sub_fantasmaPersigue fantasma(), a
                    sub_nuevosValores fantasma(), a
                End If

            End If

        Next ptosClave

        '-----------------------------------------------------------
        x = Int((fantasma(a).x + fantasma(a).velX + fantasma(a).ancho * fantasma(a).sumarAncho) / TILE_X)
        y = Int((fantasma(a).y + fantasma(a).velY + fantasma(a).alto * fantasma(a).sumarAlto) / TILE_Y)

        If Not check_colisionEscenario(x, y) Then
            fantasma(a).x = fantasma(a).x + fantasma(a).velX * fantasma(a).vel
            fantasma(a).y = fantasma(a).y + fantasma(a).velY * fantasma(a).vel

            ' *** ESCAPATORIAS ***
            If fantasma(a).x > (NRO_COLUMNAS + 1) * TILE_X And fantasma(a).velX > 0 Then fantasma(a).x = 0
            If fantasma(a).x < 0 And fantasma(a).velX < 0 Then fantasma(a).x = (NRO_COLUMNAS + 1) * TILE_X

        Else
            perseguir = Int(Rnd * 10)

            If perseguir < 5 + nivel Then
                sub_fantasmaPersigue fantasma(), a
            Else
                sub_elegirOtraDireccion fantasma(), a
            End If

            sub_nuevosValores fantasma(), a
        End If

        '---------------------------------------------
        sub_dibujaFantasmas fantasma(), a

        '---------------------------------------------
        If Not fantasmasAzules Then
            If check_colisionFantasmas(fantasma(), pacman, a) And pacman.dies = 0 Then
                pacman.dies = 1
                pacman.vueltasDies = 0
                _SndPlayCopy sonido_pacmanDies
            End If
        Else
            If check_colisionFantasmas(fantasma(), pacman, a) And pacman.dies = 0 And fantasma(a).comido = 0 Then
                ptosComeFantasmas = ptosComeFantasmas + 1

                Select Case ptosComeFantasmas
                    Case 1
                        puntos = puntos + 200
                    Case 2
                        puntos = puntos + 400
                    Case 3
                        puntos = puntos + 800
                    Case Else
                        puntos = puntos + 1600
                End Select

                fantasma(a).comido = 1
                inicia_showPtos fantasma(a).x, fantasma(a).y, ptosComeFantasmas, a
                _SndPlayCopy sonido_eatingGhost
            End If
        End If

    Next a

End Sub

'------------------------------------------------------------
Sub sub_elegirOtraDireccion (fantasma() As fantasma, a As Integer)

    Dim numeroRnd As Integer

    Do
        numeroRnd = Int(Rnd * 4) + 1
    Loop Until numeroRnd <> fantasma(a).direccion

    fantasma(a).direccion = numeroRnd

End Sub

'------------------------------------------------------------
Sub sub_nuevosValores (fantasma() As fantasma, a As Integer)

    Shared arrayDireccionesPac() As Integer

    fantasma(a).velX = arrayDireccionesPac(fantasma(a).direccion, 1)
    fantasma(a).velY = arrayDireccionesPac(fantasma(a).direccion, 2)
    fantasma(a).sumarAncho = arrayDireccionesPac(fantasma(a).direccion, 3)
    fantasma(a).sumarAlto = arrayDireccionesPac(fantasma(a).direccion, 4)

End Sub

'------------------------------------------------------------
Sub sub_fantasmaPersigue (fantasma() As fantasma, a As Integer)

    Dim hor_ver As Integer

    Shared pacman As pacman

    hor_ver = Int(Rnd * 10)

    If hor_ver < 5 Then
        If fantasma(a).y < pacman.y Then fantasma(a).direccion = 4 Else fantasma(a).direccion = 3
    Else
        If fantasma(a).x < pacman.x Then fantasma(a).direccion = 2 Else fantasma(a).direccion = 1
    End If

End Sub

'------------------------------------------------------------
Sub sub_dibujaFantasmas (fantasma() As fantasma, a As Integer)

    Dim x As Integer
    Dim y As Integer
    Dim ancho As Integer
    Dim alto As Integer

    Shared fantasmaImg() As Long
    Shared fantasmaAzulImg() As Long

    Shared animaFantasmas As Integer
    Shared fantasmasAzules As _Bit
    Shared duracionAzules As Integer
    Shared ptosComeFantasmas As Integer

    Shared sonido_azules As Long

    '---------------------------------------------
    x = fantasma(a).x
    y = fantasma(a).y
    ancho = fantasma(a).ancho
    alto = fantasma(a).alto

    If duracionAzules > 0 Then duracionAzules = duracionAzules - 1

    If duracionAzules = 2 Then _SndStop sonido_azules

    If duracionAzules = 0 Then
        fantasmasAzules = 0
        fantasma(a).comido = 0
        ptosComeFantasmas = 0
    End If

    '---------------------------------------------
    If animaFantasmas < VEL_ANIMA_PAC / 2 Then

        If Not fantasmasAzules Then
            _PutImage (x, y)-Step(ancho, alto), fantasmaImg(a)
        Else
            If fantasma(a).comido = 0 Then _PutImage (x, y)-Step(ancho, alto), fantasmaAzulImg(1)
        End If
    Else
        If Not fantasmasAzules Then
            _PutImage (x, y)-Step(ancho, alto), fantasmaImg(a + 4)
        Else
            If fantasma(a).comido = 0 And duracionAzules < 400 Then
                _PutImage (x, y)-Step(ancho, alto), fantasmaAzulImg(2)
            ElseIf fantasma(a).comido = 0 And duracionAzules >= 400 Then
                _PutImage (x, y)-Step(ancho, alto), fantasmaAzulImg(1)
            End If
        End If

    End If

    sub_dibujaOjos fantasma(), a

    animaFantasmas = animaFantasmas + 1
    If animaFantasmas >= VEL_ANIMA_PAC Then animaFantasmas = 0

End Sub

'------------------------------------------------------------
Sub sub_dibujaOjos (fantasma() As fantasma, a As Integer)

    Dim direcc As Integer
    Shared ojosImg() As Long

    direcc = fantasma(a).direccion
    _PutImage (fantasma(a).x, fantasma(a).y)-Step(fantasma(a).ancho, fantasma(a).alto), ojosImg(direcc)

End Sub

'------------------------------------------------------------
Sub sub_pausaComeFantasmas (showP() As showP)

    Dim a As Integer

    For a = 1 To 4
        If showP(a).cDown = SHOW_PTOS_CDOWN - 5 Then Sleep 1
    Next a

End Sub

'==================================================================
Sub la_fruta

    Dim qfruta As Integer
    Dim ptosClave As Integer

    Dim x As Integer
    Dim y As Integer
    Dim pcx As Integer
    Dim pcy As Integer

    Shared fruta As fruta
    Shared arrayPtosClaveX() As Integer
    Shared arrayPtosClaveY() As Integer
    Shared nivel As Integer
    Shared puntos As Long

    Shared frutaImg() As Long
    Shared sonido_eatingCherry As Long

    '-----------------------------------
    If fruta.comido > 0 Then Exit Sub

    '-----------------------------------
    For ptosClave = 1 To 20

        pcx = arrayPtosClaveX(ptosClave) * TILE_X
        pcy = arrayPtosClaveY(ptosClave) * TILE_Y

        If fruta.x = pcx And fruta.y = pcy Then
            sub_elegirOtraDireccionFruta fruta
            sub_nuevosValoresFruta fruta
        End If

    Next ptosClave

    '-----------------------------------------------------------
    x = Int((fruta.x + fruta.velX + fruta.ancho * fruta.sumarAncho) / TILE_X)
    y = Int((fruta.y + fruta.velY + fruta.alto * fruta.sumarAlto) / TILE_Y)

    If Not check_colisionEscenario(x, y) Then
        fruta.x = fruta.x + fruta.velX * fruta.vel
        fruta.y = fruta.y + fruta.velY * fruta.vel

        ' *** ESCAPATORIAS ***
        If fruta.x > (NRO_COLUMNAS + 1) * TILE_X And fruta.velX > 0 Then fruta.x = 0
        If fruta.x < 0 And fruta.velX < 0 Then fruta.x = (NRO_COLUMNAS + 1) * TILE_X

    Else
        sub_elegirOtraDireccionFruta fruta
        sub_nuevosValoresFruta fruta
    End If

    qfruta = nivel
    If qfruta > 4 Then qfruta = 4

    _PutImage (fruta.x, fruta.y)-Step(fruta.ancho, fruta.alto), frutaImg(qfruta)

    If check_colisionFruta(fruta) Then
        'soniquete 100, 500
        _SndPlayCopy sonido_eatingCherry

        Select Case nivel
            Case 1
                puntos = puntos + 1000
                fruta.idShow = 5
            Case 2
                puntos = puntos + 3000
                fruta.idShow = 6
            Case 3
                puntos = puntos + 5000
                fruta.idShow = 7
            Case Else
                puntos = puntos + 8000
                fruta.idShow = 8
        End Select

        fruta.comido = 1
        inicia_showPtos fruta.x, fruta.y, fruta.idShow, 5
    End If

End Sub

'------------------------------------------------------------
Sub sub_elegirOtraDireccionFruta (fruta As fruta)

    Dim numeroRnd As Integer

    Do
        numeroRnd = Int(Rnd * 4) + 1
    Loop Until numeroRnd <> fruta.direccion

    fruta.direccion = numeroRnd

End Sub

'------------------------------------------------------------
Sub sub_nuevosValoresFruta (fruta As fruta)

    Shared arrayDireccionesPac() As Integer

    fruta.velX = arrayDireccionesPac(fruta.direccion, 1)
    fruta.velY = arrayDireccionesPac(fruta.direccion, 2)
    fruta.sumarAncho = arrayDireccionesPac(fruta.direccion, 3)
    fruta.sumarAlto = arrayDireccionesPac(fruta.direccion, 4)

End Sub

'-----------------------------------------------------------
Function check_colisionEscenario (x As Integer, y As Integer)

    Shared arrayEsc() As Integer

    check_colisionEscenario = 0
    If x > NRO_COLUMNAS Or x < 1 Then Exit Function

    If arrayEsc(x, y) = 9 Then check_colisionEscenario = -1

End Function

'-----------------------------------------------------------
Function check_colisionPuntitos (puntitos() As puntitos, pacman As pacman, a As Integer, corr)

    check_colisionPuntitos = 0
    If puntitos(a).x + corr < pacman.x + pacman.ancho - corr Then
        If puntitos(a).x + puntitos(a).ancho - corr > pacman.x + corr Then
            If puntitos(a).y + corr < pacman.y + pacman.alto - corr Then
                If puntitos(a).y + puntitos(a).alto - corr > pacman.y + corr Then
                    check_colisionPuntitos = -1
                End If
            End If
        End If
    End If

End Function

'-----------------------------------------------------------
Function check_colisionFruta (fruta As fruta)

    Dim corr As Integer
    Shared pacman As pacman

    corr = 4
    check_colisionFruta = 0
    If fruta.x + corr < pacman.x + pacman.ancho - corr Then
        If fruta.x + fruta.ancho - corr > pacman.x + corr Then
            If fruta.y + corr < pacman.y + pacman.alto - corr Then
                If fruta.y + fruta.alto - corr > pacman.y + corr Then
                    check_colisionFruta = -1
                End If
            End If
        End If
    End If

End Function

'-----------------------------------------------------------
Function check_colisionFantasmas (fantasma() As fantasma, pacman As pacman, a As Integer)

    Dim corr As Integer

    corr = 6
    check_colisionFantasmas = 0
    If fantasma(a).x + corr < pacman.x + pacman.ancho - corr Then
        If fantasma(a).x + fantasma(a).ancho - corr > pacman.x + corr Then
            If fantasma(a).y + corr < pacman.y + pacman.alto - corr Then
                If fantasma(a).y + fantasma(a).alto - corr > pacman.y + corr Then
                    check_colisionFantasmas = -1
                End If
            End If
        End If
    End If

End Function

'------------------------------------------------------------
Sub inicia_showPtos (x As Integer, y As Integer, id As Integer, nro As Integer)

    Shared showP() As showP

    showP(nro).cDown = SHOW_PTOS_CDOWN
    showP(nro).x = x
    showP(nro).y = y
    showP(nro).idImg = id

End Sub

'------------------------------------------------------------
Sub mostrarShowPtos

    Dim a As Integer
    Dim numeroItems As Integer
    Dim img As Integer

    Shared showP() As showP
    Shared showImg() As Long

    '------------------------------
    numeroItems = 5

    For a = 1 To numeroItems
        If showP(a).cDown > 0 Then

            img = showP(a).idImg
            _PutImage (showP(a).x, showP(a).y)-Step(showP(a).ancho, showP(a).alto), showImg(img)

            If showP(a).cDown > 0 Then showP(a).cDown = showP(a).cDown - 1
        End If
    Next a

End Sub

'-----------------------------------------------------------
Sub soniquete (uno As Integer, dos As Integer)

    Dim a As Integer

    For a = uno To dos Step 50
        Sound a, 0.2
    Next a

End Sub

'-----------------------------------------------------------------------
Sub cuadro (x As Integer, y As Integer, ancho As Integer, alto As Integer)

    Line (x - 5, y - 5)-Step(ancho + 10, alto + 10), gris, BF
    Line (x, y)-Step(ancho, alto), grisSuelo, BF

End Sub

'-----------------------------------------------------------
Sub mostrarMarcadores

    Dim a As Integer
    Dim fila As Integer

    Shared puntos As Long
    Shared nivel As Integer
    Shared vidas As Integer
    Shared nombre() As String
    Shared record() As Long
    Shared pacmanImg() As Long

    '--------------------------------------

    If vidas > 0 Then
        For a = 1 To vidas
            _PutImage (Int(RES_X / 1.3) + a * 30, 10)-Step(28, 28), pacmanImg(1)
        Next a
    End If

    fila = 2
    Color amarillo, azulado
    Locate fila, 6
    Print " Puntos:";

    Color verde, azulado
    Print Using "######"; puntos

    Color amarillo, azulado
    Locate fila, 28
    Print " Record:";

    Color verde, azulado
    Print Using "######"; record(1);

    Color azulc, azulado
    Print " [ "; nombre(1); " ] "

    Color amarillo, azulado
    Locate fila, 65
    Print " Nivel:";

    Color verde, azulado
    Print Using "##"; nivel

End Sub

'-----------------------------------------------------------
Sub mostrar_records (record() As Long, rnivel() As Integer, nombre() As String, coordY As Integer)

    Dim a As Integer

    For a = 1 To 9
        Color amarillo, azulado
        Locate a + coordY, 25
        Print LTrim$(Str$(a)); ". "

        Color verde, azulado
        Locate a + coordY, 29
        Print nombre(a)

        Color amarillo, azulado
        Locate a + coordY, 62
        Print Using "##"; rnivel(a)

        Locate a + coordY, 70
        Print Using "######"; record(a)
    Next a

End Sub

'-----------------------------------------------------------
Sub check_records (record() As Long, rnivel() As Integer, nombre() As String, archivo As String)

    Dim a As Integer
    Dim batir As Integer
    Dim introNombre As String

    Shared puntos As Long
    Shared nivel As Integer

    '---------------------------------------
    batir = 0
    _KeyClear

    Open archivo For Output As #1

    For a = 1 To 9

        If puntos >= record(a) And batir = 0 Then
            batir = -1
            Locate 7, 10
            Input " ENHORABUENA! NUEVO RECORD! Introduce tu nombre: "; introNombre

            Write #1, puntos
            Write #1, nivel
            Write #1, introNombre
        Else
            Write #1, record(a + batir)
            Write #1, rnivel(a + batir)
            Write #1, nombre(a + batir)
        End If

    Next a

    Close #1

End Sub

'-----------------------------------------------------------
Sub pantallaPresentacion (ciclos As Integer)

    Dim x As Single
    Dim y As Single

    Shared presen As presen
    Shared tituloPacJon As Long

    _PutImage (presen.x, presen.y)-Step(presen.ancho, presen.alto), tituloPacJon

    If presen.ancho < RES_X / 1.5 Then
        presen.x = presen.x - 1
        presen.y = presen.y - 0.3
        presen.ancho = presen.ancho + 2
        presen.alto = presen.alto + 0.6
    End If

    If ciclos < VEL_ANIMA_PAC Then
        Locate 22, 38
        Print " Pulse ENTER para comenzar... "
    End If

End Sub

'-----------------------------------------------------------
Sub pacman_fantasmas_presentacion (pfp As presen)

    Dim corr As Integer

    Shared ciclos As Integer
    Shared pacmanImg() As Long
    Shared fantasmaImg() As Long
    Shared fantasmaAzulImg() As Long
    Shared ojosImg() As Long

    '--------------------------------------------
    corr = TILE_Y

    pfp.x = pfp.x + pfp.vel
    ciclos = ciclos + 1

    If pfp.x > RES_X And pfp.vel > 0 Then
        pfp.vel = -2
    ElseIf pfp.x < -RES_X / 2 And pfp.vel < 0 Then
        pfp.vel = 2
    End If

    '--------------------------------------------
    If pfp.vel > 0 Then

        If ciclos < VEL_ANIMA_PAC Then
            _PutImage (pfp.x, pfp.y - corr)-Step(pfp.ancho, pfp.alto), pacmanImg(1)
            _PutImage (pfp.x + TILE_X * 2, pfp.y - corr)-Step(pfp.ancho, pfp.alto), fantasmaAzulImg(1)
            _PutImage (pfp.x + TILE_X * 2, pfp.y - corr)-Step(pfp.ancho, pfp.alto), ojosImg(2)
        Else
            _PutImage (pfp.x, pfp.y - corr)-Step(pfp.ancho, pfp.alto), pacmanImg(2)
            _PutImage (pfp.x + TILE_X * 2, pfp.y - corr)-Step(pfp.ancho, pfp.alto), fantasmaImg(7)
            _PutImage (pfp.x + TILE_X * 2, pfp.y - corr)-Step(pfp.ancho, pfp.alto), ojosImg(2)
        End If
    Else
        If ciclos < VEL_ANIMA_PAC Then
            _PutImage (pfp.x, pfp.y - corr)-Step(pfp.ancho, pfp.alto), pacmanImg(3)
            _PutImage (pfp.x + TILE_X * 2, pfp.y - corr)-Step(pfp.ancho, pfp.alto), fantasmaImg(3)
            _PutImage (pfp.x + TILE_X * 2, pfp.y - corr)-Step(pfp.ancho, pfp.alto), ojosImg(1)
        Else
            _PutImage (pfp.x, pfp.y - corr)-Step(pfp.ancho, pfp.alto), pacmanImg(4)
            _PutImage (pfp.x + TILE_X * 2, pfp.y - corr)-Step(pfp.ancho, pfp.alto), fantasmaImg(7)
            _PutImage (pfp.x + TILE_X * 2, pfp.y - corr)-Step(pfp.ancho, pfp.alto), ojosImg(1)
        End If

    End If

End Sub

'-----------------------------------------------------------
Sub updatesNivelX

    Dim a As Integer

    Shared fotogramas As Integer
    Shared momento_actual As Integer
    Shared cadencia As Integer
    Shared ciclos As Integer
    Shared nivel_superado As _Bit
    Shared exit_Esc As _Bit
    Shared game_over As _Bit
    Shared contPuntitosComidos As Integer
    Shared fantasmasAzules As _Bit
    Shared duracionAzules As Integer
    Shared animaFantasmas As Integer
    Shared ptosComeFantasmas As Integer
    Shared wakaEnd As Integer

    Shared pacman As pacman
    Shared fantasma() As fantasma
    Shared fruta As fruta
    Shared showP() As showP
    Shared puntitos() As puntitos
    Shared ptosGordos() As puntitos

    fotogramas = fotogramas + 2
    cadencia = 0
    ciclos = 0

    momento_actual = 0
    nivel_superado = 0
    exit_Esc = 0
    game_over = 0

    contPuntitosComidos = 0

    fantasmasAzules = 0
    duracionAzules = 0
    animaFantasmas = 0
    ptosComeFantasmas = 0

    wakaEnd = 0

    sub_updatePacmanNivelX pacman
    sub_updatesFantasmasNivelX fantasma()
    sub_updatesFrutaNivelX fruta
    sub_updateShowPNivelX showP()
    sub_updatesPuntitosNivelX puntitos()
    sub_updatesPtosGordosNivelX ptosGordos()

End Sub

'-----------------------------------------------------------
Sub sub_updatePacmanNivelX (pacman As pacman)

    pacman.x = 10 * TILE_X
    pacman.y = 5 * TILE_Y
    pacman.velX = 1
    pacman.velY = 0
    pacman.vel = 2
    pacman.sumarAlto = 0
    pacman.sumarAncho = 1
    pacman.pulsada = 2
    pacman.anima = 0
    pacman.diesAnima = 0

End Sub

'-----------------------------------------------------------
Sub sub_updatesFantasmasNivelX (fantasma() As fantasma)

    Dim a As Integer

    fantasma(1).x = 3 * TILE_X
    fantasma(2).x = 6 * TILE_X
    fantasma(3).x = 8 * TILE_X
    fantasma(4).x = 10 * TILE_X

    For a = 1 To NRO_FANTASMAS
        fantasma(a).y = 9 * TILE_Y
        fantasma(a).velX = 1
        fantasma(a).velY = 0
        fantasma(a).vel = 2
        fantasma(a).tipoF = a
        fantasma(a).sumarAlto = 0
        fantasma(a).sumarAncho = 1
        fantasma(a).direccion = 2
        fantasma(a).comido = 0
        fantasma(a).idShow = 1
    Next a

End Sub

'-----------------------------------------------------------
Sub sub_updatesFrutaNivelX (fruta As fruta)

    fruta.x = 10 * TILE_X
    fruta.y = 12 * TILE_Y
    fruta.velX = 1
    fruta.velY = 0
    fruta.vel = 2
    fruta.direccion = 1
    fruta.sumarAlto = 0
    fruta.sumarAncho = 1
    fruta.comido = 0
    fruta.idShow = 1

End Sub

'-----------------------------------------------------------
Sub sub_updateShowPNivelX (showP() As showP)

    Dim a As Integer

    For a = 1 To 5
        showP(a).x = 0
        showP(a).y = 0
        showP(a).ancho = TILE_X * 2
        showP(a).alto = TILE_Y * 2
        showP(a).idImg = 1
        showP(a).cDown = 0
    Next a

End Sub

'-----------------------------------------------------------
Sub sub_updatesPuntitosNivelX (puntitos() As puntitos)

    Dim a As Integer
    Dim x As Integer
    Dim y As Integer

    Shared arrayEsc() As Integer

    a = 0
    For y = 1 To NRO_FILAS
        For x = 1 To NRO_COLUMNAS

            If arrayEsc(x, y) = 1 Then
                a = a + 1
                puntitos(a).visible = 1
            End If

        Next x
    Next y

End Sub

'-----------------------------------------------------------
Sub sub_updatesPtosGordosNivelX (ptosGordos() As puntitos)

    Dim a As Integer

    For a = 1 To NRO_PTOS_GORDOS
        ptosGordos(a).visible = 1
    Next a

End Sub

'-----------------------------------------------------------
Sub updatesSonido

    Shared sonido_gameOver As Long
    Shared sonido_go As Long
    Shared sonido_levelUp As Long
    Shared sonido_extralive As Long
    Shared sonido_azules As Long
    Shared sonido_pacmanDies As Long
    Shared sonido_eatingCherry As Long
    Shared sonido_eatingGhost As Long
    Shared sonido_inicioNivel As Long
    Shared sonido_interMision As Long
    Shared sonido_sirena As Long
    Shared sonido_wakawaka As Long

    sonido_levelUp = _SndOpen("levelup.mp3")
    sonido_azules = _SndOpen("pacmanazules.mp3")
    sonido_pacmanDies = _SndOpen("pacmandies.mp3")
    sonido_eatingCherry = _SndOpen("pacmaneatingcherry.mp3")
    sonido_eatingGhost = _SndOpen("pacmaneatinghost.mp3")
    sonido_inicioNivel = _SndOpen("pacmaninicionivel.mp3")
    sonido_interMision = _SndOpen("pacmanintermision.mp3")
    sonido_sirena = _SndOpen("pacmansirena.mp3")
    sonido_wakawaka = _SndOpen("pacmanwakawaka.mp3")
    sonido_gameOver = _SndOpen("gameoveretro.mp3")
    sonido_go = _SndOpen("gameover.mp3")
    sonido_levelUp = _SndOpen("levelup.mp3")
    sonido_extralive = _SndOpen("extralive.mp3")

End Sub

'-----------------------------------------------------------
Sub updatesGraficos

    Dim a As Integer

    Shared pacmanImg() As Long
    Shared fantasmaImg() As Long
    Shared fantasmaAzulImg() As Long
    Shared ojosImg() As Long
    Shared frutaImg() As Long
    Shared showImg() As Long
    Shared ptoGordoImg As Long
    Shared preparado As Long
    Shared pacGameOver As Long
    Shared tituloPacJon As Long

    For a = 1 To 8
        pacmanImg(a) = _LoadImage("pacman" + LTrim$(Str$(a)) + ".png")
        fantasmaImg(a) = _LoadImage("fantas" + LTrim$(Str$(a)) + ".png")
        showImg(a) = _LoadImage("ptos" + LTrim$(Str$(a)) + ".png")
    Next a

    For a = 1 To 4
        ojosImg(a) = _LoadImage("ojos" + LTrim$(Str$(a)) + ".png")
        frutaImg(a) = _LoadImage("item" + LTrim$(Str$(a)) + ".png")
    Next a

    fantasmaAzulImg(1) = _LoadImage("fantasmaAzul1.png")
    fantasmaAzulImg(2) = _LoadImage("fantasmaAzul2.png")
    ptoGordoImg = _LoadImage("ptoGordo.png")
    preparado = _LoadImage("preparado.png")
    pacGameOver = _LoadImage("pacGameOver.png")
    tituloPacJon = _LoadImage("presenpacjon.png")

End Sub

'-----------------------------------------------------------
Sub updatesGenerales

    Dim a As Integer

    Shared fotogramas As Integer
    Shared momento_actual As Integer
    Shared cadencia As Integer
    Shared ciclos As Integer
    Shared puntos As Long
    Shared nivel As Integer
    Shared vidas As Integer
    Shared extraL As _Bit
    Shared record() As Long
    Shared rnivel() As Integer
    Shared nombre() As String
    Shared archivo As String
    Shared nivel_superado As _Bit
    Shared exit_Esc As _Bit
    Shared game_over As _Bit
    Shared contPuntitosComidos As Integer
    Shared nro_puntitos As Integer
    Shared fantasmasAzules As _Bit
    Shared duracionAzules As Integer
    Shared animaFantasmas As Integer
    Shared ptosComeFantasmas As Integer
    Shared wakaEnd As Integer

    Shared pacman As pacman
    Shared arrayDireccionesPac() As Integer
    Shared fantasma() As fantasma
    Shared arrayPtosClaveX() As Integer
    Shared arrayPtosClaveY() As Integer
    Shared fruta As fruta
    Shared showP() As showP
    Shared puntitos() As puntitos
    Shared ptosGordos() As puntitos
    Shared presen As presen
    Shared arrayEsc() As Integer

    fotogramas = FPS
    cadencia = 0
    ciclos = 0

    puntos = 0
    nivel = 1
    vidas = 3
    extraL = 0

    momento_actual = -1
    nivel_superado = 0
    exit_Esc = 0
    game_over = 0

    contPuntitosComidos = 0
    nro_puntitos = 0

    fantasmasAzules = 0
    duracionAzules = 0
    animaFantasmas = 0
    ptosComeFantasmas = 0

    wakaEnd = 0
    archivo = "recordsPacClonQB.dat"
    update_records record(), rnivel(), nombre(), archivo

    instancia_arrayEscenario arrayEsc()
    instancia_pacman pacman, arrayDireccionesPac()
    instancia_fantasmas fantasma(), arrayPtosClaveX(), arrayPtosClaveY()
    instancia_fruta fruta
    instancia_showP showP()
    instancia_puntitos puntitos(), nro_puntitos
    instancia_ptosGordos ptosGordos(), nro_puntitos
    instancia_presentacion presen

End Sub

'-----------------------------------------------------------
Sub update_records (record() As Long, rnivel() As Integer, nombre() As String, archivo As String)

    Dim a As Integer

    If _FileExists(archivo) Then
        Open archivo For Input As #1
        For a = 1 To 9
            Input #1, record(a)
            Input #1, rnivel(a)
            Input #1, nombre(a)
        Next a
        Close #1
    Else
        Print " Archivo de records  "; archivo; "  No encontrado!"
        Print " Pulse una tecla para continuar..."
        _Display
        Sleep 9
    End If

End Sub

'-----------------------------------------------------------
Sub instancia_pacman (pacman As pacman, arrayDireccionesPac() As Integer)

    pacman.x = 10 * TILE_X
    pacman.y = 5 * TILE_Y
    pacman.radio = Int(TILE_Y / 2)
    pacman.ancho = TILE_X
    pacman.alto = TILE_Y
    pacman.velX = 1
    pacman.velY = 0
    pacman.vel = 2
    pacman.sumarAlto = 0
    pacman.sumarAncho = 1
    pacman.pulsada = 2
    pacman.anima = 0
    pacman.diesAnima = 0
    pacman.dies = 0

    '-------------------------------
    arrayDireccionesPac(1, 1) = -1
    arrayDireccionesPac(1, 2) = 0
    arrayDireccionesPac(1, 3) = 0
    arrayDireccionesPac(1, 4) = 0

    arrayDireccionesPac(2, 1) = 1
    arrayDireccionesPac(2, 2) = 0
    arrayDireccionesPac(2, 3) = 1
    arrayDireccionesPac(2, 4) = 0

    arrayDireccionesPac(3, 1) = 0
    arrayDireccionesPac(3, 2) = -1
    arrayDireccionesPac(3, 3) = 0
    arrayDireccionesPac(3, 4) = 0

    arrayDireccionesPac(4, 1) = 0
    arrayDireccionesPac(4, 2) = 1
    arrayDireccionesPac(4, 3) = 0
    arrayDireccionesPac(4, 4) = 1

End Sub

'-----------------------------------------------------------
Sub instancia_fantasmas (fantasma() As fantasma, arrayPtosClaveX() As Integer, arrayPtosClaveY() As Integer)

    Dim a As Integer

    fantasma(1).x = 3 * TILE_X
    fantasma(2).x = 6 * TILE_X
    fantasma(3).x = 8 * TILE_X
    fantasma(4).x = 10 * TILE_X

    For a = 1 To NRO_FANTASMAS
        fantasma(a).y = 9 * TILE_Y
        fantasma(a).radio = TILE_Y / 2
        fantasma(a).ancho = TILE_X
        fantasma(a).alto = TILE_Y
        fantasma(a).velX = 1
        fantasma(a).velY = 0
        fantasma(a).vel = 2
        fantasma(a).tipoF = a
        fantasma(a).sumarAncho = 1
        fantasma(a).sumarAlto = 0
        fantasma(a).direccion = 2
        fantasma(a).comido = 0
        fantasma(a).idShow = 1
    Next a

    '----------------------------
    arrayPtosClaveX(1) = 5
    arrayPtosClaveY(1) = 2

    arrayPtosClaveX(2) = 15
    arrayPtosClaveY(2) = 2

    arrayPtosClaveX(3) = 5
    arrayPtosClaveY(3) = 5

    arrayPtosClaveX(4) = 7
    arrayPtosClaveY(4) = 5

    arrayPtosClaveX(5) = 13
    arrayPtosClaveY(5) = 5

    arrayPtosClaveX(6) = 15
    arrayPtosClaveY(6) = 5

    arrayPtosClaveX(7) = 5
    arrayPtosClaveY(7) = 9

    arrayPtosClaveX(8) = 7
    arrayPtosClaveY(8) = 9

    arrayPtosClaveX(9) = 13
    arrayPtosClaveY(9) = 9

    arrayPtosClaveX(10) = 15
    arrayPtosClaveY(10) = 9

    arrayPtosClaveX(11) = 2
    arrayPtosClaveY(11) = 12

    arrayPtosClaveX(12) = 5
    arrayPtosClaveY(12) = 12

    arrayPtosClaveX(13) = 7
    arrayPtosClaveY(13) = 12

    arrayPtosClaveX(14) = 13
    arrayPtosClaveY(14) = 12

    arrayPtosClaveX(15) = 15
    arrayPtosClaveY(15) = 12

    arrayPtosClaveX(16) = 18
    arrayPtosClaveY(16) = 12

    arrayPtosClaveX(17) = 5
    arrayPtosClaveY(17) = 14

    arrayPtosClaveX(18) = 7
    arrayPtosClaveY(18) = 14

    arrayPtosClaveX(19) = 13
    arrayPtosClaveY(19) = 14

    arrayPtosClaveX(20) = 15
    arrayPtosClaveY(20) = 14

End Sub

'-----------------------------------------------------------
Sub instancia_fruta (fruta As fruta)

    fruta.x = 10 * TILE_X
    fruta.y = 12 * TILE_Y
    fruta.radio = Int(TILE_Y / 2)
    fruta.ancho = TILE_X
    fruta.alto = TILE_Y
    fruta.velX = 1
    fruta.velY = 0
    fruta.vel = 2
    fruta.direccion = 1
    fruta.sumarAlto = 0
    fruta.sumarAncho = 1
    fruta.comido = 0
    fruta.idShow = 1

End Sub

'-----------------------------------------------------------
Sub instancia_showP (showP() As showP)

    Dim a As Integer

    For a = 1 To 5
        showP(a).x = 0
        showP(a).y = 0
        showP(a).ancho = TILE_X * 2
        showP(a).alto = TILE_Y * 2
        showP(a).idImg = 0
        showP(a).cDown = 0
    Next a

End Sub

'-----------------------------------------------------------
Sub instancia_puntitos (puntitos() As puntitos, nro_puntitos As Integer)

    Dim a As Integer
    Dim x As Integer
    Dim y As Integer

    Shared arrayEsc() As Integer

    a = 0
    For y = 1 To NRO_FILAS
        For x = 1 To NRO_COLUMNAS

            If arrayEsc(x, y) = 1 Then
                a = a + 1

                puntitos(a).x = Int(x * TILE_X + TILE_X / 2)
                puntitos(a).y = Int(y * TILE_Y + TILE_Y / 2)
                puntitos(a).radio = Int(TILE_Y / 15)
                puntitos(a).alto = Int(TILE_Y / 10)
                puntitos(a).ancho = Int(TILE_X / 10)
                puntitos(a).visible = 1

                nro_puntitos = nro_puntitos + 1
            End If

        Next x
    Next y

End Sub

'-----------------------------------------------------------
Sub instancia_ptosGordos (ptosGordos() As puntitos, nro_puntitos As Integer)

    Dim a As Integer

    ptosGordos(1).x = Int(TILE_X * 2)
    ptosGordos(1).y = Int(TILE_Y * 2)
    ptosGordos(2).x = Int(TILE_X * 18)
    ptosGordos(2).y = Int(TILE_Y * 2)
    ptosGordos(3).x = Int(TILE_X * 2)
    ptosGordos(3).y = Int(TILE_Y * 14)
    ptosGordos(4).x = Int(TILE_X * 18)
    ptosGordos(4).y = Int(TILE_Y * 14)

    For a = 1 To NRO_PTOS_GORDOS
        ptosGordos(a).radio = Int(TILE_Y / 2)
        ptosGordos(a).alto = Int(TILE_Y)
        ptosGordos(a).ancho = Int(TILE_X)
        ptosGordos(a).visible = 1
        nro_puntitos = nro_puntitos + 1
    Next a

End Sub

'-----------------------------------------------------------
Sub instancia_arrayEscenario (arrayEsc() As Integer)

    Dim a As Integer
    Dim x As Integer
    Dim y As Integer
    Dim valor As Integer

    Restore
    For y = 1 To NRO_FILAS
        For x = 1 To NRO_COLUMNAS
            Read valor
            arrayEsc(x, y) = valor
        Next x
    Next y

End Sub

'-----------------------------------------------------------
Sub instancia_presentacion (presen As presen)

    presen.x = RES_X / 2
    presen.y = RES_Y / 4
    presen.ancho = 2
    presen.alto = 2
    presen.vel = 0

    instancia_pfp

End Sub

'-----------------------------------------------------------
Sub instancia_pfp

    Shared pfp As presen

    pfp.x = RES_X / 2
    pfp.y = RES_Y / 2
    pfp.ancho = TILE_X
    pfp.alto = TILE_Y
    pfp.vel = 2

End Sub

'-----------------------------------------------------------
Sub salir
    Shared sonido_gameOver As Long
    Shared sonido_go As Long
    Shared sonido_levelUp As Long
    Shared sonido_extralive As Long
    Shared sonido_azules As Long
    Shared sonido_pacmanDies As Long
    Shared sonido_eatingCherry As Long
    Shared sonido_eatingGhost As Long
    Shared sonido_inicioNivel As Long
    Shared sonido_interMision As Long
    Shared sonido_sirena As Long
    Shared sonido_wakawaka As Long

    _SndClose sonido_gameOver
    _SndClose sonido_go
    _SndClose sonido_levelUp
    _SndClose sonido_extralive
    _SndClose sonido_azules
    _SndClose sonido_pacmanDies
    _SndClose sonido_eatingCherry
    _SndClose sonido_eatingGhost
    _SndClose sonido_inicioNivel
    _SndClose sonido_interMision
    _SndClose sonido_sirena
    _SndClose sonido_wakawaka

End Sub









