# ML-and-NLP-Projects
This repository contains all the projects I did during my Master 2 of MLDS in Université Paris Cité

Projet_Deep_Learning : Mise en place d'un classifieur supervisé basé sur les pseudo-labels. Ce notebook contient le travail réalisé dans le cadre d'un projet de Deep Learning, qui consistait à mettre en place un réseau de neurones capable d’effectuer une prédiction des labels pour les images de MNIST avec un dataset pour l’apprentissage composé d’uniquement 100 images labelisés en utilisant la méthode d'apprentissage semi-supervisé pour les réseaux d'apprentissage profond, de la manière qui a été proposée dans l'article scientifique intitulé "Pseudo-label : The simple and Efficient Semi-Supervised Learning Method for Deep Neural Networks".

Projet_NLP : Analyse textuelle et exploratoire. Ce notebook illustre les traitements de texte nécessaires  réalisés sur un jeu de données, ainsi que des statistiques et une  classification non supervisé du dataset.

Comparaison_AppSup_1 : Ce notebook contient la première partie d'une comparaison des méthodes de clustering, en utilisant les datasets Classic4 et BBC, et les représentation textuelles Word2vec et GloVe1 pour la vectorisation des données textuelles, nous avons appliqué divers algorithmes de clustering. On a pu comparé les résultats de k-means, spectral clustering, HDBSCAN, CAH ( ward, single, complete, average) qui ont été appliqués sur les données d'origine c'est à dire avant réduction, et sur les données après leur réduction ( avec PCA, t-SNE, UMAP,  autoencoders) c'est à dire via des approches tandem. On a pu aussi comparé des méthodes de clustering combinés ( réduction de dimentionalité et clustering simultanément) à savoir reduced k-means, Factorial Kmeans, DCN, DKM. Une intéprétation de l'ensemble des résultats obtenus ( via les métrics NMI, ARI) est incluse en fin du notebook.

Comparaison_AppSup_2 :  Le même travail a été réalisé que dans la première partie, sauf que la représentation textuelle a été réalisé avec BERT et RoBERTa, et en plus des Dataset Classic4 et BBC, on a utilisé deux datasets personnelles non labélisés  Article 1 et Article 2


