SELECT T.GOODSCODE,
       T.GOODSTITLE,
       T.PERSIANTITLE,
       T.GOODSUNITTITLE,
       T.PHYSICALLOCATIONTITLE,
       inv.CERTAIN_INVENTORY MOJODIGHATEI,
       inv.AVAILABLE_INVENTORY MOJOODIMOVAGHAT
  FROM (SELECT GOODS.GOODSCODE,
               GOODS.GOODSTITLE,
               GOODSSTATE.PERSIANTITLE,
               GOODSUNIT.GOODSUNITTITLE,
               PL.PHYSICALLOCATIONTITLE,
               GOODS.IDGOODS,
               PL.IDPHYSICALLOCATION
        FROM DOCHEADER
          INNER JOIN DOCITEM
            ON DOCHEADER.DOCHEADERID = DOCITEM.DOCHEADERREL
          INNER JOIN DOCITEMDETAIL DID
            ON DID.DOCHEADERREL = DOCHEADER.DOCHEADERID
          INNER JOIN PHYSICALLOCATION PL
            ON PL.IDPHYSICALLOCATION = DID.PHYSICALLOCATIONREL
          INNER JOIN DOCTYPE
            ON DOCTYPE.IDDOCTYPE = DOCHEADER.DOCTYPEREL
          INNER JOIN ORGPOSITION EXORG
            ON DOCHEADER.EXPORTEROID = EXORG.IDPOSITION
          INNER JOIN ORGPOSITION AUDORG
            ON DOCHEADER.AUDIENCEOID = AUDORG.IDPOSITION
          INNER JOIN P_CATALOGVALUE
            ON DOCHEADER.DOCSTATUSCID = CATALOGVALUEID
          INNER JOIN GOODS
            ON DOCITEM.GOODSREL = GOODS.IDGOODS
          INNER JOIN GOODSUNIT
            ON GOODSUNIT.IDGOODSUNIT = DOCITEM.GOODSUNITREL
          LEFT JOIN P_CATALOGVALUE GOODSSTATE
            ON DOCITEM.GOODSSTATUSCID = GOODSSTATE.CATALOGVALUEID
          INNER JOIN STOCK
            ON STOCK.IDSTOCK = DOCHEADER.STOCKREL
          INNER JOIN STOCKPERIOD
            ON STOCKPERIOD.IDSTOCKPERIOD = DOCHEADER.STOCKPERIODREL
          INNER JOIN GOODSGOODSGROUP
            ON GOODS.IDGOODS = GOODSGOODSGROUP.GOODSREL
          INNER JOIN GOODSGROUP
            ON GOODSGROUP.IDGOODSGROUP = GOODSGOODSGROUP.GOODSGROUPREL
        WHERE (STOCK.IDSTOCK = 188212)
          AND (189452 = STOCKPERIOD.IDSTOCKPERIOD)
          AND (1124 = GOODS.IDGOODS)
          ---   and (GoodsGoodsgroup.Goodsgrouprel = 0 or 0 = 0  )
          AND (PL.IDPHYSICALLOCATION IN (SELECT IDPHYSICALLOCATION
              FROM PHYSICALLOCATION
              WHERE NVL(ISDELETE, 0) = 0
                AND ISACTIVE = 1))
          AND (GOODS.ISACTIVE = 1)
        --??? AND (STOCK.ORGPOSITIONOID = 0    OR 0 = 0)
        --??? AND (inv.CERTAIN_INVENTORY = 0 OR 0 = 0)
        /*		AND ((Docheader.DOCDATE  TO_Date('','ddmmyyyy HHMISS AM') and  Docheader.DOCDATE  TO_Date('','ddmmyyyy HHMISS AM'))
         		OR  (Docheader.DOCDATE  TO_Date('','ddmmyyyy HHMISS AM') and TO_Date('','ddmmyyyy HHMISS AM') IS NULL  )  
                OR  (TO_Date('','ddmmyyyy HHMISS AM') IS NULL and Docheader.DOCDATE  TO_Date('','ddmmyyyy HHMISS AM') ) 
                OR  (TO_Date('','ddmmyyyy HHMISS AM') IS NULL and TO_Date('','ddmmyyyy HHMISS AM') IS NULL  ))*/
        GROUP BY GOODS.GOODSCODE,
                 GOODS.GOODSTITLE,
                 GOODSSTATE.PERSIANTITLE,
                 GOODSUNIT.GOODSUNITTITLE,
                 PL.PHYSICALLOCATIONTITLE,
                 GOODS.IDGOODS,
                 PL.IDPHYSICALLOCATION) T
    CROSS JOIN TABLE (FN_GET_PHYSICALINVENTORY(T.IDGOODS, T.IDPHYSICALLOCATION)) inv
  GROUP BY T.GOODSCODE,
           T.GOODSTITLE,
           T.PERSIANTITLE,
           T.GOODSUNITTITLE,
           T.PHYSICALLOCATIONTITLE,
           inv.CERTAIN_INVENTORY,
           inv.AVAILABLE_INVENTORY