#2012 10 18 I.Zliobaite
#last modified 2014 10 31 - komentarai
#panasus kandidatai, dendrogramos

#source('plot_dendrograms.R')

#Sys.setlocale(locale="Lithuanian")
Sys.setlocale(loc="lt_LT.UTF-8")

patekusiu_partiju_numeriai <- c(1,3,5,6,7,8,9)
patekusiu_partiju_kodai <- c('ls','dp','ts','dk','le','sd','tt')
patekusiu_partiju_pavadinimai <- c('Liberalų sąjudis','Darbo partija','Tėvynės sąjunga','Drąsos kelias','Lenkų rinkimų akcija','Socialdemokratų partija','Tvarka ir teisingumas');

name_file_name <- paste('3_data/raw_data/','Seimo rinkimai 2012- Kandidat- partijos ir numeriai num.csv',sep='')
vardai <- read.csv(name_file_name, header = FALSE)


for (sk in 1:length(patekusiu_partiju_numeriai))
{
  partija_now <- patekusiu_partiju_numeriai[sk]
  
  file_name <- paste('3_data/',patekusiu_partiju_kodai[sk],'_koreliacijos.csv',sep='')
  kand_file_name <- paste('3_data/',patekusiu_partiju_kodai[sk],'_kandidatai.csv',sep='')
  out_file_name <- paste('6_plots/',patekusiu_partiju_kodai[sk],'_dendro.pdf',sep='')
  out_file_name2 <- paste('6_plots/',patekusiu_partiju_kodai[sk],'_mds.pdf',sep='')
  
  ind_vardai_now <- which(vardai[,1]==partija_now)
  vardai_now <-vardai[ind_vardai_now,]
  ind_sorted <- order(strtoi(vardai_now[,4]))
  kandidatai <- vardai_now[ind_sorted,2]
    
  correlations <- read.csv(file_name, header = FALSE)
  kandidatai_no <- read.csv(kand_file_name, header = FALSE)
  
  
  distance <- as.dist(1-correlations)
  hc <- hclust(distance,method="complete")
  
  pdf(out_file_name, enc="ISOLatin7", paper="a4r",width=20)
  par(ps = 5)
  plot(hc,main = patekusiu_partiju_pavadinimai[sk], labels = t(kandidatai), xlab="", ylab="",axes=FALSE)
  dev.off()
  
  #mds
  fit <- cmdscale(distance,eig=TRUE, k=2) # k kiek dimensiju
  
  # plot solution 
  x <- fit$points[,1]
  y <- fit$points[,2]
  pdf(out_file_name2, enc="ISOLatin7", paper="a4",width=20)
  par(ps = 6)
  plot(x, y, main=patekusiu_partiju_pavadinimai[sk],	type="n", axes=FALSE, frame.plot=TRUE)
  text(x, y, labels = t(kandidatai))
  dev.off()
  
}