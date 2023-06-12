--
-- Planned every 10 minutes
--
SET ANSI_WARNINGS OFF;
declare @cies varchar(1000), @cie VARCHAR(50), @sql varchar(max)='';

set @cies = 'ALGO PROD,L_ATELIER,LA MANUFACTURE,LA VANOISE,MALLETERIE,S_A_S_ LA MAROQUINERIE';
declare tblcursor CURSOR FOR
SELECT value as cie
FROM string_split(@cies, ',');
open tblcursor;
fetch next from tblcursor into @cie;
while @@fetch_status=0
begin
    -- Step 1 : MAJ Rcpt Qty at Due Date
    set @sql='
update ['+@cie+'$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802]
set [Rcpt Qty at Due Date]=t2.qty from
    (
        select
        pl.[Document No_],
        pl.[Line No_],
        (case when SUM(prl.Quantity)>0 then SUM(prl.Quantity) else 0 end) as qty
    from ['+@cie+'$Purchase Line] pl
    left join ['+@cie+'$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802] ple on ple.[Document No_]=pl.[Document No_] and ple.[Line No_]=pl.[Line No_]
    left join ['+@cie+'$Purch_ Rcpt_ Line] prl on (
        prl.[Order No_]=pl.[Document No_]
        and prl.[Order Line No_]=pl.[Line No_]
    )
    join ['+@cie+'$Purch_ Rcpt_ Header] prh on (
        prh.No_=prl.[Document No_]
        and prh.[Document Date]<=(
            case when (ple.[Initial Promised Date] is null or ple.[Initial Promised Date]=''1753-01-01 00:00:00'')
            then pl.[Promised Receipt Date]
            else ple.[Initial Promised Date]
        end)
    )
    where
        pl.[Document Type]=1
        and pl.[Promised Receipt Date]<>''1753-01-01 00:00:00''
        and pl.[Quantity Received]>0
    group by pl.[Document No_], pl.[Line No_]
    ) t2
    where ['+@cie+'$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Document No_]=t2.[Document No_]
    and ['+@cie+'$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Line No_]=t2.[Line No_]';
    exec(@sql);
    -- Step 2 : MAJ Last Rcpt Date
    set @sql='
    update ['+@cie+'$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802]
set [Last Rcpt Date]=t2.pdate
from 
(select
	MAX(prh.[Document Date]) as pdate
	, pl.[Document No_]
	, pl.[Line No_]
	, prl.Quantity
from ['+@cie+'$Purchase Line] pl
left join ['+@cie+'$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802] ple on  ple.[Document No_]=pl.[Document No_] and ple.[Line No_]=pl.[Line No_]
left join ['+@cie+'$Purch_ Rcpt_ Line] prl on (
	prl.[Order No_]=pl.[Document No_]
    and prl.[Order Line No_]=pl.[Line No_]
)
join ['+@cie+'$Purch_ Rcpt_ Header] prh on prh.No_=prl.[Document No_]
where 
	pl.[Document Type]=1 
    and prl.[Posting Date]<>''1753-01-01 00:00:00''
    and prl.[Quantity]>0
group by pl.[Document No_], pl.[Line No_], prl.Quantity) t2
WHERE
['+@cie+'$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Document No_]=t2.[Document No_]
and ['+@cie+'$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Line No_]=t2.[Line No_]
    ';
    EXEC(@sql);
    -- Step 3 : MAJ Prod Order Line
    set @sql='
    update ['+@cie+'$Prod_ Order Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802]
set [Last Reception Date]=t2.pdate
from 
(select
	MAX(ile.[Document Date]) as pdate
	, ile.[Order No_]
	, ile.[Order Line No_]
from ['+@cie+'$Prod_ Order Line] pol
left join ['+@cie+'$Item Ledger Entry] ile on ile.[Order No_]=pol.[Prod_ Order No_] and ile.[Order Line No_]=pol.[Line No_]
left join ['+@cie+'$Prod_ Order Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802] pole on pole.[Prod_ Order No_]=pol.[Prod_ Order No_] and pole.[Line No_]=pol.[Line No_]
where 
	ile.[Entry Type]=6
group by ile.[Order No_], ile.[Order Line No_]
) t2
WHERE
['+@cie+'$Prod_ Order Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Prod_ Order No_]=t2.[Order No_]
and ['+@cie+'$Prod_ Order Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Line No_]=t2.[Order Line No_]
    ';
    EXEC(@sql);
    fetch next from tblcursor into @cie;
END
close tblcursor
DEALLOCATE tblcursor;
