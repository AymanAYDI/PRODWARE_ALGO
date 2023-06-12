/*
FieldClass = FlowField;
Editable = false;
CalcFormula = Max ("Item Ledger Entry"."Posting Date" WHERE ("Entry Type" = FILTER (Output),
                                                            "Order No." = field ("Prod. Order No."),
                                                            "Order Line No." = field ("Line No.")));
*/

update [ALGO PROD$Prod_ Order Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802]
set [Last Reception Date]=t2.pdate
from 
(select
	MAX(ile.[Posting Date]) as pdate
	, ile.[Order No_]
	, ile.[Order Line No_]
from [ALGO PROD$Prod_ Order Line] pol
left join [ALGO PROD$Item Ledger Entry] ile on ile.[Order No_]=pol.[Prod_ Order No_] and ile.[Order Line No_]=pol.[Line No_]
left join [ALGO PROD$Prod_ Order Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802] pole on pole.[Prod_ Order No_]=pol.[Prod_ Order No_] and pole.[Line No_]=pol.[Line No_]
where 
	ile.[Entry Type]=6
group by ile.[Order No_], ile.[Order Line No_]
) t2
WHERE
[ALGO PROD$Prod_ Order Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Prod_ Order No_]=t2.[Order No_]
and [ALGO PROD$Prod_ Order Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Line No_]=t2.[Order Line No_]