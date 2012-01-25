evaluated.ip128.e96.r48.eval1.repro1 <- read.table('evaluated-ip128-e96-r48-eval1-repro1.dat')
evaluated.ip128.e96.r48.eval1.repro1.new <- read.table('evaluated-ip128-e96-r48-eval1-repro1-new.dat')
evaluated.ip128.e96.r24.eval1.repro2<- read.table('evaluated-ip128-e96-r24-eval1-repro2.dat')
evaluated.ip128.e96.r24.eval1.repro2.new <- read.table('evaluated-ip128-e96-r24-eval1-repro2-new.dat')
plot(evaluated.ip128.e96.r48.eval1.repro1$V1, type='l')
lines(evaluated.ip128.e96.r48.eval1.repro1.new$V1, col='red')
lines(evaluated.ip128.e96.r24.eval1.repro2.new$V1, col='blue')
lines(evaluated.ip128.e96.r24.eval1.repro2$V1, col='green')

