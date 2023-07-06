# ML-and-NLP-Projects
Ce  repository contient les projets effectués dans le cadre de Mon master 2 " Apprentissage automatique pour la Science des Données" 

## Projet_Deep_Learning : Mise en place d'un classifieur supervisé basé sur les pseudo-labels. 
Ce notebook contient le travail réalisé dans le cadre d'un projet de Deep Learning, qui consistait à mettre en place un réseau de neurones capable d’effectuer une prédiction des labels pour les images de MNIST avec un dataset pour l’apprentissage composé d’uniquement 100 images labelisés en utilisant la méthode d'apprentissage semi-supervisé pour les réseaux d'apprentissage profond, de la manière qui a été proposée dans l'article scientifique intitulé "Pseudo-label : The simple and Efficient Semi-Supervised Learning Method for Deep Neural Networks".

## Projet_NLP : Analyse textuelle et exploratoire. 
Ce notebook illustre les traitements de texte nécessaires  réalisés sur un jeu de données, ainsi que des statistiques et une  classification non supervisé du dataset. Implémentation avec Python

## Projet_Clustering_1 : 
Ce notebook contient la première partie d'une comparaison des méthodes de clustering, en utilisant les datasets Classic4 et BBC, et les représentation textuelles Word2vec et GloVe1 pour la vectorisation des données textuelles, nous avons appliqué divers algorithmes de clustering. On a pu comparé les résultats de k-means, spectral clustering, HDBSCAN, CAH ( ward, single, complete, average) qui ont été appliqués sur les données d'origine c'est à dire avant réduction, et sur les données après leur réduction ( avec PCA, t-SNE, UMAP,  autoencoders) c'est à dire via des approches tandem. On a pu aussi comparé des méthodes de clustering combinés ( réduction de dimentionalité et clustering simultanément) à savoir reduced k-means, Factorial Kmeans, DCN, DKM. Une intéprétation de l'ensemble des résultats obtenus ( via les métrics NMI, ARI) est incluse en fin du notebook. Implémentation avec Python

## Projet_Clustering_2 :  
Le même travail a été réalisé que dans la première partie, sauf que la représentation textuelle a été réalisé avec BERT et RoBERTa, et en plus des Dataset Classic4 et BBC, on a utilisé deux datasets personnelles non labélisés  Article 1 et Article 2. Implémentation avec Python

## Projet_Classification_automatique : 
L'objectif de ce projet est l'application et la comparaison des diverses méthodes de classification automatique à savoir Régression logistique, SVM, Naive Bayes, KNN, Random Forest, CART ... en utilisant deux types de datasets. Le premier dataset contient les données bancaires et personnelles de clients, ce dataset sera utilisé pour entrainer un modèle afin de déterminer si un client est bon ou mauvais par rapport à sa capacité à rembourser ou non son crédit. Le deuxième dataset est sous la forme de données relationnelles représentées avec deux types d’information, une matrice des valeurs objets/caractéristiques et un graphe des liens entre objets. A travers ce notebook nous présentons les étapes suivis pour chacun des datasets, du preprocessing jusqu'à l'entrainement et l'évaluation des divers modèles, ainsi que l'analyse des résultats obtenues. Implémentation avec Python.

## TP_App_renforcement : 
Dans ce TP, j'ai éffectué l'implémentation en python de quelques algorithmes d'apprentissage par renforcement ( SARSA, Q-learning, Monte carlo). Implémentation en python

## TP_App_Supervise : 
Dans ce TP,  j'ai implémenté un code permettande d'effectuer la simulation et visualisation d'une distribution gaussienne multivariée, la simulation d’un mélange de distributions gaussiennes multivariées, mais aussi découpage du jeu de données en données d'apprentissage et données de test. Dans le but d'évaluer la qualité de la classification sur notre jeu de données, on a gardé 20% des données pour la partie test. Implémentation en R.


## TP_Clustering&Modèles : 
A travers ce TP on a mis en pratique les différentes méthodes de clustering sur 5 tables de grandes tailles et dimension. la grande dimentionnalité de ces jeux de données rend la visualisation difficile. Le tableau JAFFE contient 213 images de 7 différentes expressions faciales de 10 visages féminin japonnais. Le label fait référence à la personne photographiés ( de 1 à 10). Les tables MFEA, MNIST, USPS, JAFFE et OPTIDIGITS sont des jeux de données d’images représentant des chiffres écrit à la mains où chaque label indique à quel chiffre l’image représente. Chaque tableau à un nombre spécifique d'image avec un nombre de pixel fixé pour chaque dataset. On a effectué un  partionnement des observations avec Nbclust et kmeans et CAH ( single, complete, ward, average), en comparant les partitions de Nbclust et HCPC. Nous avons aussi appliqué les approches, en testant le modèle EM de deux packages : Rmixmod et Mclust.


