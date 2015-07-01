library(ggplot2)
library(plyr)
plot_gflops <- function(file.openmp, file.cilk, plot_title, outfile) {
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
    ggtitle(plot_title)
  
  ggsave(outfile, width=6, height=5)
}

plot(file.openmp = "normsq.openmp.txt",
     file.cilk   = "normsq.cilk.txt",
     plot_title  = "Norm squared of one 5M double vector",
     outfile     = "normsq.gflops.png")

plot(file.openmp = "dot.openmp.txt",
     file.cilk   = "dot.cilk.txt",
     plot_title  = "Dot product of two 5M double vectors",
     outfile     = "dot.gflops.png")

plot(file.openmp = "sum.openmp.txt",
     file.cilk   = "sum.cilk.txt",
     plot_title  = "Element-wise sum of two 5M double vectors",
     outfile     = "sum.gflops.png")
