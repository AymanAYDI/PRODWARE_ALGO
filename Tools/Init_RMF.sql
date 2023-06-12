UPDATE [ALGO PROD$Item$934c1a8f-1bd7-47a1-a1f6-6fc0515a1802]
set [Raw material family]=(case 
    when SUBSTRING(No_, 1, 3)='FCU' then 1
    when SUBSTRING(No_, 1, 3) IN ('FTI', 'FTO') then 2
    when SUBSTRING(No_, 1, 3) IN ('FBI', 'FCL') then 3
    when SUBSTRING(No_, 1, 4) IN ('FZIM') then 3
    when SUBSTRING(No_, 1, 3) IN ('MPA', 'MCO', 'MDI') then 4
    when SUBSTRING(No_, 1, 3) IN ('FBO', 'FCO', 'FDI', 'FSE') then 0
    else 0
end)