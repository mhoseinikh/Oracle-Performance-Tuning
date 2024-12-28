SELECT  
	goods.goodscode,
	goods.goodstitle,
	goodsstate.persiantitle,
	GoodsUnit.GOODSUNITTITLE,
	pl.PhysicallocationTitle,
	inv.CERTAIN_INVENTORY MojodiGhatei,
    inv.AVAILABLE_INVENTORY MojoodiMovaghat
FROM
    DocHeader
    INNER JOIN DocItem ON DocHeader.DocHeaderID = DocItem.DOCHEADERREL
    INNER JOIN DocItemDetail did on did.DocHeaderRel    = DocHeader.DocHeaderID
    INNER JOIN Physicallocation pl on pl.idPhysicallocation    = did.Physicallocationrel
    INNER JOIN DocType ON DocType.IDDOCTYPE = DocHeader.DOCTYPEREL
    INNER JOIN orgposition EXorg ON DocHeader.EXPORTEROID = EXorg.IDPOSITION
    INNER JOIN orgposition AUDorg ON DocHeader.AUDIENCEOID = AUDorg.IDPOSITION
    INNER JOIN p_CatalogValue ON DocHeader.DOCSTATUSCID = CatalogValueID
    INNER JOIN Goods ON DocItem.GOODSREL = Goods.IDGOODS
    INNER JOIN GoodsUnit ON GoodsUnit.IDGOODSUNIT = DocItem.GOODSUNITREL
    LEFT JOIN p_CatalogValue goodsstate ON DocItem.GOODSSTATUSCID = goodsstate.CatalogValueID
    INNER JOIN stock ON stock.IDSTOCK = DocHeader.STOCKREL
    INNER JOIN stockperiod ON stockperiod.IDSTOCKPERIOD = DocHeader.STOCKPERIODREL
    INNER JOIN GoodsGoodsgroup ON Goods.IDGOODS = GoodsGoodsgroup.Goodsrel
    INNER JOIN Goodsgroup ON goodsgroup.idgoodsgroup = GoodsGoodsgroup.goodsgrouprel
    CROSS JOIN
          TABLE(FN_Get_PhysicalInventory(Goods.IDGOODS, pl.IdPhysicallocation)
    ) inv
     WHERE (stock.IDSTOCK =  188212 or  188212 = 0)
       and (189452 =stockperiod.IDSTOCKPERIOD or 189452 = 0 )
       and (1124 = Goods.IDGOODS  or  1124 = 0 )
    ---   and (GoodsGoodsgroup.Goodsgrouprel = 0 or 0 = 0  )
     and (pl.IdPhysicallocation in(SELECT IdPhysicalLocation from PhysicalLocation where NVL(IsDelete,0) = 0 AND IsActive = 1)  )
       and ( Goods.ISACTIVE = 1   )
       and (stock.ORGPOSITIONOID = 0 or 0 =0 )
       and (     inv.CERTAIN_INVENTORY = 0 or 0 = 0)   
		AND ((Docheader.DOCDATE  TO_Date('','ddmmyyyy HHMISS AM') and  Docheader.DOCDATE  TO_Date('','ddmmyyyy HHMISS AM'))
 		OR  (Docheader.DOCDATE  TO_Date('','ddmmyyyy HHMISS AM') and TO_Date('','ddmmyyyy HHMISS AM') IS NULL  )  
        OR  (TO_Date('','ddmmyyyy HHMISS AM') IS NULL and Docheader.DOCDATE  TO_Date('','ddmmyyyy HHMISS AM') ) 
        OR  (TO_Date('','ddmmyyyy HHMISS AM') IS NULL and TO_Date('','ddmmyyyy HHMISS AM') IS NULL  ))

  GROUP BY
    goods.goodscode,
    goods.goodstitle,
    goodsstate.persiantitle,
    GoodsUnit.GOODSUNITTITLE,   
     pl.PhysicallocationTitle,
    inv.CERTAIN_INVENTORY,
    inv.AVAILABLE_INVENTORY
 