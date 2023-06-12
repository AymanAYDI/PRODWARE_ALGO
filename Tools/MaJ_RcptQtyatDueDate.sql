--
-- Planned every 10 minutes
--
update [ALGO PROD$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802] set
[Rcpt Qty at Due Date]=t2.qty from
(
    select
        pl.[Document No_],
        pl.[Line No_],
        (case when SUM(prl.Quantity)>0 then SUM(prl.Quantity) else 0 end) as qty
    from [ALGO PROD$Purchase Line] pl
    left join [ALGO PROD$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802] ple on ple.[Document No_]=pl.[Document No_] and ple.[Line No_]=pl.[Line No_]
    left join [ALGO PROD$Purch_ Rcpt_ Line] prl on (
        prl.[Order No_]=pl.[Document No_]
        and prl.[Order Line No_]=pl.[Line No_]
        and prl.[Posting Date]<=(case when (ple.[Initial Promised Date] is null or ple.[Initial Promised Date]='1753-01-01 00:00:00') then pl.[Promised Receipt Date] else ple.[Initial Promised Date] end)
    )
    where 
        pl.[Document Type]=1 
        and pl.[Promised Receipt Date]<>'1753-01-01 00:00:00'
        and pl.[Quantity Received]>0
    group by pl.[Document No_], pl.[Line No_]
) t2
where [ALGO PROD$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Document No_]=t2.[Document No_]
and [ALGO PROD$Purchase Line$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802].[Line No_]=t2.[Line No_]