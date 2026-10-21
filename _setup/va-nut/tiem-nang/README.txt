Va tab Tiem nang / Chien hon trong Lo Ren (Flash/2.png), 22/10/2026. Chi tiet: README muc 30.
Loi: ForgeMainView.changeHandler case 2 (Tiem nang) va case 3 (Chien hon) khong dat currentPanelIndex
 -> bang tui chung cua tiem ren giu danh sach tab truoc (Tang cap) de len danh sach rieng cua tab -> bo do vao thi mat khoi danh sach.
Sua: chen "this.currentPanelIndex = StoreMainView.WISHBEAD;" vao cuoi case 2 va case 3 (WISHBEAD + ISFRIST = an bang tui chung).

Cach lam lai (can JRE + JPEXS FFDec, winget install JPEXS.FFDec):
  node _setup/va-nut/timham.js 2.png store/forge/ForgeMainView store.forge:ForgeMainView/changeHandler   -> body 9
  ffdec-cli -replace 2.png 2-moi.png store.forge.ForgeMainView ForgeMainView-changeHandler.pcode 9
Kiem: chi 1 tag DoABC (store/forge/ForgeMainView) doi, +18 byte. md5 goc (da va nut) 41b2ace9..., sau va ae83726e...
Hoan tac tren VPS: copy C:\Gunny92\Flash\2.png.bak20261022 de len 2.png.
