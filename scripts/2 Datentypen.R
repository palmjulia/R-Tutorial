#### Vektoren ####

#unnamed vector
x <- c(4,5,1)
x

#named vector
y <- c(a=7, b=3, c=2)
y

#Länge bestimmen
length(x)

#Einzelnes Element aufrufen
x[2]
y["c"]

#mehrere Elemente aufrufen
x[c(1,3)]

#typ bestimmen
class(x)




#### Vektorentypen ####

#character
char <- c("apple", "banana")
class(char)

#Einzelner Buchstabe ist auch nur character vector Länge 1
letter <- "a"
class(letter)
length(letter)

#Logical
log1 <- c(TRUE, FALSE, TRUE)
log2 <- c(T, T, F)
log3 <- c(1<2, "A"=="B", 3!=5)
class(log1)





#### Rechnen mit Vektoren ####
# einfache Mathematik
x + y
x/y
x^y

# einfache Logik
log1 & log2
log1 | log2




#### Listen ####

#unnamed list
l1 <- list(1, "a", c(TRUE, TRUE), list(1,"x"))
l1
class(l1)
length(l1)

#named list
l2 <- list(zahl = 1, buchstabe = "a", vektor = c(TRUE, TRUE), liste = list(1,"x"))
l2
names(l2)

#gib 3. Element als Teilliste zurück
l1[3]

#gib 3. Element selbst zurück
l1[[3]]

#mit Namen indizieren
l2["buchstabe"]
l2[["buchstabe"]]





#### Data.frames ####

#Erzeugung
d <- data.frame(name = c("Joe", "Ann", "Max"),
                age = c(43, 37, 12),
                sex = c("male", "female", "male")
                )

#Aufruf in Konsole
d

#Aufruf in Viewer
View(d)


