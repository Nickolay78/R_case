# Заванаження необхідної бази даних
load ("crimes_ukr-REG.RData")

# Підключення бібліотеки
library (tidyverse)

# Створення датафрейму для візуалізації
data<-select(crimes_Reg_f1, c("Year","Region","Article","ACC"))
data<-subset(data,(Year>2020&Article=="185"))

data<-subset(data,!str_detect(Region,"залізниця"))

# Побудова візуалізації
vis1<-ggplot(data,
             mapping = aes(x=Region, y=ACC, fill=ACC, label=ACC))+
  geom_bar(stat = "identity")+
  facet_wrap(.~Year, ncol=1)+
  theme(legend.title = element_blank(),
      axis.text.x=element_text(angle = 90))+
  geom_text(aes(angle=90,y=max(data$ACC/2)))+
  ggtitle ("Регіональний розподіл облікованих крадіжок (2021-2022)")+
  ylab ("Кількість облікованих проваджень")+
  xlab ("Адміністративно-територіальні одиниці")

# Виведення візуалізації у вікно Plots
vis1

# Збереження візуалізації у файл
ggsave (filename = "diagram.png",vis1, 
        width = 32, height = 18, dpi = 300, units = "cm")


           