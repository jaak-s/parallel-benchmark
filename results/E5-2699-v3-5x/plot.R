########    dot    ########
file.openmp = "dot.openmp.txt"
file.cilk   = "dot.cilk.txt"
plot_title  = "Dot product of two vectors of 5M doubles"
out         = "dot.gflops.png"

dot.openmp = read.csv(file.openmp, header = FALSE, sep = "\t")
dot.cilk   = read.csv(file.cilk,   header = FALSE, sep = "\t")
dot = rbind(
  cbind(dot.openmp, method="openmp"),
  cbind(dot.cilk,   method="cilk")
)
colnames(dot)[1] = "Ncores"
colnames(dot)[3] = "VectorSize"
colnames(dot)[5] = "time"
colnames(dot)[7] = "GFLOPs"

library(ggplot2)
library(scales)
qplot( data=dot, y = GFLOPs, x = Ncores, geom=c("line", "point"), color=method, 
       ylab="GFLOP/s", stat="summary", fun.y="mean")

dot.sd = ddply(dot, .(method, Ncores), summarize, sd = sd(GFLOPs), mean = mean(GFLOPs))

ggplot( data=dot.sd, aes(y = mean, x = Ncores, color=method) ) +
  geom_point() + geom_line() + 
  geom_errorbar(mapping = aes(ymax = mean + sd, ymin = mean - sd), alpha=0.6) +
  ylab("Mean GFLOP/s") +
  ggtitle("Dot product of two vectors of 5M doubles")

ggsave(out, width=5, height=5)
