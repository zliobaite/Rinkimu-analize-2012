# 2012 10 18 I.Zliobaite
# last modified: 2014 10 29 - sutvarkytas apipavidalinimas ir komentarai

#labai letai veikia, nzinau kodel, geriau naudoti MATLAB alternatyva run_prepare_data.m

# balsavimo duomenu paruosimas
# duomenys is cia http://data.ukmin.lt/duomenys_rinkimu.html

# Analizuojamos partijos, kurios pateko i Seima
# 1 ls - Liberalu sajudis
# 3 dp - Darbo partija 
# 5 ts - Tevynes sajunga
# 6 dk - Drasos kelias
# 7 le - Lenku rinkimu akcija
# 8 sd - Socialdemokratai
# 9 tt - Tvarka ir teisingumas

input_file <- '3_data/raw_data/pirmumo_balsai.csv'

param_min_skirtumas <- 5 #per daugiau kaip 5 vietas aukstyn
param_didele_koreliacija <- 0.5 #nuo kiek jau skaitosi didele koreliacija
patekusiu_partiju_numeriai <- c(1,3,5,6,7,8,9)
patekusiu_partiju_kodai <- c('ls','dp','ts','dk','le','sd','tt')

#duomenu nuskaitymas
#apylinke,sarasas,pr_reitingas,pab_reitingas,balsai
data <- read.csv(input_file, header = TRUE)
apylinkes <- unique(data[,1])
apylinkes <- sort(apylinkes)
no_apylinkiu <- length(apylinkes)

for (sk in 1:length(patekusiu_partiju_numeriai))
{
  partija_now <- patekusiu_partiju_numeriai[sk]

  #duomenu filtravimas, viena partija
  ind_now <- which(data[,2]==partija_now)
  n <- length(ind_now)
  print(n)
  data_now <- data[ind_now,]
  kandidatai <- unique(data_now[,3])
  kandidatai <- sort(kandidatai)
  no_kandidatu <- length(kandidatai)

  kan_file_name <- paste('3_data/',patekusiu_partiju_kodai[sk],'_kandidatai.csv',sep='')
  write.table(kandidatai, file = kan_file_name,row.names=FALSE,col.names=FALSE)
  
  #inicializavimas
  skirtumai <- matrix(0,no_apylinkiu,no_kandidatu) #tarp pradzios reitingo ir pabaigos reitingo
  balsai <- matrix(0,no_apylinkiu,no_kandidatu) #is viso balsu
  #ciklas per vienos partijos duomenis
  for (sk2 in 1:n)
  {
    apylinkes_nu <- which(apylinkes == data_now[sk2,1])
    kandidato_nu <- which(kandidatai == data_now[sk2,3])
    skirtumai[apylinkes_nu,kandidato_nu] <- data_now[sk2,3]-data_now[sk2,4]
    balsai[apylinkes_nu,kandidato_nu] <- data_now[sk2,5]
  }
  remove(data_now)
  
  #balsu proporcija apylinkeje (is visu tai partijai pirmumo balsu, kiek kandidatas gavo)
  smb <- as.matrix(apply(balsai,1,sum))
  ind0 <- which(smb==0)
  if (length(ind0)>0)
  {
    smb[ind0] <-1
  }
  balsai_rel <- balsai/(smb %*% array(1,c(1,no_kandidatu))) 
  remove(balsai)
  
  brel_file_name = paste('3_data/',patekusiu_partiju_kodai[sk],'_balsai_rel.csv',sep='')
  write.table(balsai_rel, file = brel_file_name, row.names=FALSE,col.names=FALSE, sep = ',')
  
  #ind = which(skirtumai[1,]>param_min_skirtumas)
  
  #koreliacija tarp prop balsu, domina teigiamos
  correlations = cor(balsai_rel)
  remove(balsai_rel)
  
  cor_file_name = paste('3_data/',patekusiu_partiju_kodai[sk],'_koreliacijos.csv',sep='')
  write.table(correlations,file = cor_file_name,row.names=FALSE,col.names=FALSE, sep = ',')
  
  #idomios poros
  for (sk3 in 1:no_kandidatu) #tiek max nariu sarase
  {
    correlations[sk3,sk3]<-0 #pats su savim nesiskaito
  }

  ii <- sort(as.vector(correlations),decreasing = TRUE) #rusiuojam nuo didziausios iki maziausios
  kiek_dideliu_koreliaciju <- length(which(ii>=param_didele_koreliacija))
  
  poros = matrix(0,kiek_dideliu_koreliaciju/2,5)
  for (cik in seq(1,kiek_dideliu_koreliaciju,by = 2)) #kai surusiuojam, tai gaunasi, kad reikia ziureti kas antra
  {
    ind = which(correlations==ii[cik],arr.ind = TRUE)
    xx = ind[1,1]
    yy = ind[1,2]
    poros[(cik+1)/2,] = c(xx,yy,skirtumai[1,xx],skirtumai[1,yy],correlations[xx,yy])
  }
  
  por_file_name <- paste('3_data/',patekusiu_partiju_kodai[sk],'_poros.csv',sep='')
  write.table(poros, file = por_file_name, row.names=FALSE,col.names=FALSE, sep = ',')
  remove(skirtumai)
}