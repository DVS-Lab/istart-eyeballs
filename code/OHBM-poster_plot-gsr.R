# set working directory
setwd("~/Desktop")
maindir <- getwd()
datadir <- file.path("~/Desktop/")

# load packages
library("readxl")
library("ggplot2")
library("ggpubr")

# import data
data <- read_excel("~/Documents/Github/istart-eyeballs/derivatives/hyp_2-2_gsr_2-1/data_gsr-2-1_right.xlsx")

# Crus I
scatter <- ggplot(data,aes(x=gsr,y=CrusI))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE, linetype="dashed", colour="gray")+
  labs(x="GSR",y="Right Eye ~ CB, 2-stim>1-stim")+
  ggtitle("Crus I")+
  stat_cor(method="pearson", label.x=.0025, label.y=1.2)
scatter + scale_color_grey() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                     panel.background = element_blank(), axis.line = element_line(colour = "black"))

# Crus II
scatter <- ggplot(data,aes(x=gsr,y=CrusII))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE, linetype="dashed", colour="gray")+
  labs(x="GSR",y="Right Eye ~ CB, 2-stim>1-stim")+
  ggtitle("Crus II")+
  stat_cor(method="pearson", label.x=.0025, label.y=1.2)
scatter + scale_color_grey() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                     panel.background = element_blank(), axis.line = element_line(colour = "black"))

# Vermis VIIIa
scatter <- ggplot(data,aes(x=gsr,y=VermisVIIIa))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE, linetype="dashed", colour="gray")+
  labs(x="GSR",y="Right Eye ~ CB, 2-stim>1-stim")+
  ggtitle("Vermis VIIIa")+
  stat_cor(method="pearson", label.x=.0025, label.y=1.2)
scatter + scale_color_grey() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                     panel.background = element_blank(), axis.line = element_line(colour = "black"))

# Vermis VIIIb
scatter <- ggplot(data,aes(x=gsr,y=VermisVIIIb))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE, linetype="dashed", colour="gray")+
  labs(x="GSR",y="Right Eye ~ CB, 2-stim>1-stim")+
  ggtitle("Vermis VIIIb")+
  stat_cor(method="pearson", label.x=.0025, label.y=1.2)
scatter + scale_color_grey() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                     panel.background = element_blank(), axis.line = element_line(colour = "black"))

# Vermis IX
scatter <- ggplot(data,aes(x=gsr,y=VermisIX))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE, linetype="dashed", colour="gray")+
  labs(x="GSR",y="Right Eye ~ CB, 2-stim>1-stim")+
  ggtitle("Vermis IX")+
  stat_cor(method="pearson", label.x=.0025, label.y=1.2)
scatter + scale_color_grey() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                     panel.background = element_blank(), axis.line = element_line(colour = "black"))

