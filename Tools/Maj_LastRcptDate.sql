-- Purchase Line
/*
CalcFormula = Max ("Purch. Rcpt. Line"."Posting Date" WHERE
                                                        ("Buy-from Vendor No." = FIELD ("Buy-from Vendor No."),
                                                        "Order No." = FIELD ("Document No."),
                                                        "Order Line No." = FIELD ("Line No."),
                                                        Quantity = FILTER (<> 0)));
*/

update [ALGO PROD$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802]
set [Last Rcpt Date]=t2.pdate
from 
(select top(10)
	MAX(prl.[Posting Date]) as pdate
	, pl.[Document No_]
	, pl.[Line No_]
	, prl.Quantity
from [ALGO PROD$Purchase Line] pl
left join [ALGO PROD$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802] ple on  ple.[Document No_]=pl.[Document No_] and ple.[Line No_]=pl.[Line No_]
left join [ALGO PROD$Purch_ Rcpt_ Line] prl on (
	prl.[Order No_]=pl.[Document No_]
    and prl.[Order Line No_]=pl.[Line No_]
)
where 
	pl.[Document Type]=1 
    and prl.[Posting Date]<>'1753-01-01 00:00:00'
    and prl.[Quantity]>0
group by pl.[Document No_], pl.[Line No_], prl.Quantity) t2
WHERE
[ALGO PROD$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Document No_]=t2.[Document No_]
and [ALGO PROD$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Line No_]=t2.[Line No_]