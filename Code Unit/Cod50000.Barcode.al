codeunit 50000 "Barcode"
{
    // version CDH1.0.0.0

    //     BarCode Generator v. 0.2
    //     Copyright (C) 2006 Marco Vicentini, C.D.H.
    // 
    //     For information, please contact:
    //     C.D.H. s.r.l. - Via Ferrero 31, 10098 Rivoli (TO) ITALY
    //           web: www.cdhsrl.it      mail: info@cdhsrl.it
    // 
    // 
    // 
    // 
    // This program is free software; you can redistribute it and/or
    // modify it under the terms of the GNU General Public License
    // as published by the Free Software Foundation; either version 2
    // of the License, or (at your option) any later version.
    // You are not allowed to delete any of the information about the
    // copyright and the author(s) listed above.
    // 
    // This program is distributed in the hope that it will be useful,
    // but WITHOUT ANY WARRANTY; without even the implied warranty of
    // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    // GNU General Public License for more details.
    // 
    // You should have received a copy of the GNU General Public License
    // along with this program; if not, write to the Free Software
    // Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


    trigger OnRun()
    begin
    end;

    var
        incode: Text[15];

    procedure GenerateBarCode(InString: Text[15]) BarCodeString: Text[15]
    var
        i: Integer;
        checksum: Char;
        first: Char;
        "Table": Integer;
        WorkString: Text[14];
    begin
        FOR i := 1 TO 12 DO
            IF CharToInt(InString[i]) > -1 THEN
                WorkString[i] := InString[i];
        FOR i := 2 TO 12 DO BEGIN
            checksum := checksum + (CharToInt(InString[i]));
            i := i + 1;
        END;
        checksum := checksum * 3;
        FOR i := 1 TO 11 DO BEGIN
            checksum := checksum + (CharToInt(InString[i]));
            i := i + 1;
        END;
        WorkString[13] := IntToChar((10 - checksum MOD 10) MOD 10);
        first := CharToInt(InString[1]);
        BarCodeString[1] := IntToChar(first);
        BarCodeString[2] := (65 + CharToInt(WorkString[2]));
        FOR i := 3 TO 7 DO BEGIN
            Table := 0;
            CASE i OF
                3:
                    IF (first < 4) AND (first > 1) THEN
                        Table := 1;
                4:
                    IF (first = 0) OR (first = 4) OR (first = 7) OR (first = 8) THEN
                        Table := 1;
                5:
                    IF (first = 0) OR (first = 1) OR (first = 4) OR (first = 5) OR (first = 9) THEN
                        Table := 1;
                6:
                    IF (first = 0) OR (first = 2) OR (first = 5) OR (first = 6) OR (first = 7) THEN
                        Table := 1;
                7:
                    IF (first = 0) OR (first = 3) OR (first = 6) OR (first = 8) OR (first = 9) THEN
                        Table := 1;
            END;
            IF Table = 1 THEN
                BarCodeString[i] := (65 + CharToInt(WorkString[i]))
            ELSE
                BarCodeString[i] := (75 + CharToInt(WorkString[i]));
        END;
        BarCodeString[8] := '*';
        FOR i := 8 TO 13 DO
            BarCodeString[i + 1] := (97 + CharToInt(WorkString[i]));
        BarCodeString[15] := '+';
    end;

    procedure CharToInt(c: Char) n: Integer
    begin
        CASE c OF
            '0':
                BEGIN
                    n := 0;
                    EXIT;
                END;
            '1':
                BEGIN
                    n := 1;
                    EXIT;
                END;

            '2':
                BEGIN
                    n := 2;
                    EXIT;
                END;

            '3':
                BEGIN
                    n := 3;
                    EXIT;
                END;

            '4':
                BEGIN
                    n := 4;
                    EXIT;
                END;

            '5':
                BEGIN
                    n := 5;
                    EXIT;
                END;

            '6':
                BEGIN
                    n := 6;
                    EXIT;
                END;

            '7':
                BEGIN
                    n := 7;
                    EXIT;
                END;
            '8':
                BEGIN
                    n := 8;
                    EXIT;
                END;

            '9':
                BEGIN
                    n := 9;
                    EXIT;
                END;
            ELSE BEGIN
                n := -1;
                EXIT;
            END;
        END;
    end;

    procedure IntToChar(n: Integer) c: Char
    begin
        CASE n OF
            0:
                BEGIN
                    c := '0';
                    EXIT;
                END;
            1:
                BEGIN
                    c := '1';
                    EXIT;
                END;

            2:
                BEGIN
                    c := '2';
                    EXIT;
                END;

            3:
                BEGIN
                    c := '3';
                    EXIT;
                END;

            4:
                BEGIN
                    c := '4';
                    EXIT;
                END;

            5:
                BEGIN
                    c := '5';
                    EXIT;
                END;

            6:
                BEGIN
                    c := '6';
                    EXIT;
                END;

            7:
                BEGIN
                    c := '7';
                    EXIT;
                END;
            8:
                BEGIN
                    c := '8';
                    EXIT;
                END;

            9:
                BEGIN
                    c := '9';
                    EXIT;
                END;
            ELSE BEGIN
                c := 'X';
                EXIT;
            END;
        END;
    end;
}

