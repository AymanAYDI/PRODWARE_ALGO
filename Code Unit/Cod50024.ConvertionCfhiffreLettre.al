codeunit 50024 "ConvertionCfhiffreLettre"
{
    // version ID 3911 - ALGO -DE012011-0313


    trigger OnRun()
    begin
    end;

    var
        Text026: Label 'ZERO', Locked = true;
        Text027: Label 'CENT', Locked = true;
        Text028: Label 'ET', Locked = true;
        Text032: Label 'UN', Locked = true;
        Text033: Label 'DEUX', Locked = true;
        Text034: Label 'TROIS', Locked = true;
        Text035: Label 'QUATRE', Locked = true;
        Text036: Label 'CINQ', Locked = true;
        Text037: Label 'SIX', Locked = true;
        Text038: Label 'SEPT', Locked = true;
        Text039: Label 'HUIT', Locked = true;
        Text040: Label 'NEUF', Locked = true;
        Text041Msg: Label 'DIX', Locked = true;
        Text042Msg: Label 'ONZE', Locked = true;
        Text043Msg: Label 'DOUZE', Locked = true;
        Text044Msg: Label 'TREIZE', Locked = true;
        Text045Msg: Label 'QUATORZE', Locked = true;
        Text046Msg: Label 'QUINZE', Locked = true;
        Text047Msg: Label 'SEIZE', Locked = true;
        Text048Msg: Label 'DIX-SEPT', Locked = true;
        Text049Msg: Label 'DIX-HUIT', Locked = true;
        Text050Msg: Label 'DIX-NEUF', Locked = true;
        Text051Msg: Label 'VINGT', Locked = true;
        Text052Msg: Label 'TRENTE', Locked = true;
        Text053Msg: Label 'QUARANTE', Locked = true;
        Text054Msg: Label 'CINQUANTE', Locked = true;
        Text055Msg: Label 'SOIXANTE', Locked = true;
        Text056Msg: Label 'SOIXANTE-DIX', Locked = true;
        Text057Msg: Label 'QUATRE-VINGT', Locked = true;
        Text058Msg: Label 'QUATRE-DIX', Locked = true;
        Text059Msg: Label 'MILLE', Locked = true;
        Text060Msg: Label 'MILLION', Locked = true;
        Text061Msg: Label 'MILLIARD', Locked = true;
        Text10800Msg: Label 'EUROS', Locked = true;
        Text10801Msg: Label 'CENTIME', Locked = true;
        Chiffre: Dialog;
        DescriptionLine: array[2] of Text[500];
        i: Integer;
        Text029: Label '%1 résultat(s) en toutes lettres trop long(s)', Locked = true;
        Onestext: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        num: Decimal;

    procedure InitTextVariable()
    begin
        Onestext[1] := Text032;
        Onestext[2] := Text033;
        Onestext[3] := Text034;
        Onestext[4] := Text035;
        Onestext[5] := Text036;
        Onestext[6] := Text037;
        Onestext[7] := Text038;
        Onestext[8] := Text039;
        Onestext[9] := Text040;
        Onestext[10] := Text041Msg;
        Onestext[11] := Text042Msg;
        Onestext[12] := Text043Msg;
        Onestext[13] := Text044Msg;
        Onestext[14] := Text045Msg;
        Onestext[15] := Text046Msg;
        Onestext[16] := Text047Msg;
        Onestext[17] := Text048Msg;
        Onestext[18] := Text049Msg;
        Onestext[19] := Text050Msg;

        TensText[1] := '';
        TensText[2] := Text051Msg;
        TensText[3] := Text052Msg;
        TensText[4] := Text053Msg;
        TensText[5] := Text054Msg;
        TensText[6] := Text055Msg;
        TensText[7] := Text056Msg;
        TensText[8] := Text057Msg;
        TensText[9] := Text058Msg;

        ExponentText[1] := '';
        ExponentText[2] := Text059Msg;
        ExponentText[3] := Text060Msg;
        ExponentText[4] := Text061Msg;
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal)
    begin
        FormatNoTextFR(NoText, No);
    end;

    procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure FormatNoTextFR(var NoText: array[2] of Text[80]; No: Decimal)
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;

                IF Hundreds = 1 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027)
                ELSE
                    IF Hundreds > 1 THEN BEGIN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Onestext[Hundreds]);
                        IF (Tens * 10 + Ones) = 0 THEN
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text027 + 'S')
                        ELSE
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                    END;

                FormatTens(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

                IF PrintExponent AND (Exponent > 1) THEN
                    IF ((Hundreds * 100 + Tens * 10 + Ones) > 1) AND (Exponent <> 2) THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent] + 'S')
                    ELSE
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);

                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text10800Msg);
        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);

        No := No * 100;
        Ones := No MOD 10;
        Tens := No DIV 10;

        FormatTens(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

        IF No = 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text10801Msg)
        ELSE
            IF No > 1 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text10801Msg + 'S');
    end;

    procedure FormatTens(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; Exponent: Integer; Hundreds: Integer; Tens: Integer; Ones: Integer)
    begin
        CASE Tens OF
            9:
                BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text057Msg);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Onestext[Ones + 10]);
                END;

            8:
                IF Ones = 0 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text057Msg + 'S')
                ELSE BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text057Msg);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Onestext[Ones]);
                END;

            7:
                BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text055Msg);
                    IF Ones = 1 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Onestext[Ones + 10]);
                END;

            2:
                BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text051Msg);
                    IF Ones > 0 THEN BEGIN
                        IF Ones = 1 THEN
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
                        AddToNoText(NoText, NoTextIndex, PrintExponent, Onestext[Ones]);
                    END;
                END;

            1:
                AddToNoText(NoText, NoTextIndex, PrintExponent, Onestext[Tens * 10 + Ones]);

            0:
                BEGIN
                    IF Ones > 0 THEN
                        IF (Ones = 1) AND (Hundreds < 1) AND (Exponent = 2) THEN
                            PrintExponent := TRUE
                        ELSE
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Onestext[Ones]);
                END;

            ELSE BEGIN
                AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                IF Ones > 0 THEN BEGIN
                    IF Ones = 1 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, 'ET');
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Onestext[Ones]);
                END;
            END;
        END;
    end;

    procedure UseThisCu(var num: Decimal): Text[500]
    begin
        InitTextVariable();
        FormatNoText(DescriptionLine, num);
        EXIT(DescriptionLine[1]);
    end;
}

