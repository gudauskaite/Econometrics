parama_nacionalines2 <- read.csv2(file= "parama_nacionalines2.csv", header = TRUE)
kainu_indeksai_vartotoju <- read.csv2(file= "kainu_indeksai_vartotoju.csv", header = TRUE)
zemes_kainos3 <- read.csv2(file= "zemes_kainos3.csv", header = TRUE)

colnames(parama_nacionalines2) <- c("data", "kaina")
colnames(zemes_kainos3) <- c("data1", "kaina1")
zemes_kainos3 <- zemes_kainos3[-c(1:16), ]

library(midasr)

attach(parama_nacionalines2)
attach(zemes_kainos3)

check_mixfreq(c(kaina,kaina1))

myts1 <- ts(kaina1, start=c(2004, 1), end=c(2017, 4), frequency=4)
myts2 <- ts(kaina, start=c(2004, 1), end=c(2017, 1), frequency=1)
plot(myts2)

library(tempdisagg)

m1 <- td(myts2 ~ 1, to = "quarterly", method = "denton-cholette")
summary(m1)
print(predict(m1))
plot(predict(m1))

plot( myts2, type="l", col="red" )
par(new=TRUE)
plot( predict(m1), type="l", col="green" )

func = splinefun(x=data, y=kaina, method="fmm",  ties = mean)
func(seq(2004, 2017, 0.25))

plot( myts2, type="l", col="red" )
par(new=TRUE)
plot(func(seq(2004, 2017, 0.25)) , type="l", col="green" )

attach(kainu_indeksai_vartotoju)
myts3 <- ts(indeksas, start=c(2004, 1), end=c(2017, 12), frequency=12)

y <- diff(log(myts1), differences = 4)
x <- window(diff(myts3), start = c(2005,1))
t <- 1:length(y)
mr <- midas_r(y~t+fmls(x,3,12,nealmon),start=list(x=c(0,0,0)))
agk.test(mr)


