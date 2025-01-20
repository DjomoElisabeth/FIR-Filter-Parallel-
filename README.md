# **Filtre FIR Parallèle à 16 Échantillons (VHDL)**

## **Description du projet**

Ce projet implémente un **filtre FIR (Finite Impulse Response) parallèle** à **16 échantillons**, conçu pour fonctionner sur FPGA avec une architecture optimisée pour le traitement en pipeline. Le filtre a été conçu et testé en utilisant **Xilinx Vivado 2023.2**, en utilisant son simulateur intégré **XSim**, pour valider son comportement.

Les coefficients du filtre ont été générés en utilisant **MATLAB FDATool**, garantissant une réponse en fréquence conforme aux spécifications.

## **Justification de la structure du filtre FIR**

L'architecture du filtre FIR a été conçue pour répondre aux exigences de performances et de contraintes matérielles du FPGA :

1. **Calcul en Complément à Deux (CA2)**  
   - Toutes les opérations arithmétiques sont effectuées en complément à deux (CA2) pour assurer une gestion efficace des nombres signés sur FPGA.

2. **Architecture Parallèle avec Pipeline**  
   - Le filtre traite 16 échantillons simultanément, en utilisant une structure pipelinée pour réduire la latence et améliorer le débit.

3. **Registre de Décalage pour l'Entrée des Échantillons**  
   - Un registre de décalage est utilisé pour stocker les données d'entrée, assurant un flux continu vers les étages de calcul.

4. **Multiplication avec les Coefficients FIR**  
   - Les échantillons sont multipliés par des coefficients prédéfinis, calculés sous MATLAB et intégrés dans le design sous forme de constantes.

5. **Addition en Pipeline (Tree Adder)**  
   - Une architecture d'addition en plusieurs niveaux est utilisée pour répartir la charge de calcul et assurer des performances élevées.

6. **Horloge CAN/CNA à `clk/2`**  
   - Le système génère une horloge pour le CAN et le CNA fonctionnant à **la moitié de la fréquence principale (`clk/2`)**.

7. **Troncature et Conversion des Résultats**  
   - Les résultats de filtrage sont tronqués et formatés pour une compatibilité avec le CAN/CNA.

## **Flux de traitement du filtre**

Le processus de filtrage suit les étapes suivantes :

1. **Entrée des échantillons** → Chargement dans le registre de décalage.
2. **Multiplication** → Chaque échantillon est multiplié par son coefficient FIR.
3. **Addition** → Somme des résultats intermédiaires en plusieurs niveaux.
4. **Troncature et conversion** → Ajustement des données pour la sortie.
5. **Sortie vers le CAN/CNA** → Données envoyées en sortie filtrée.

## **Simulation et Validation (Vivado 2023.2 - XSim)**

### **Scénarios de test réalisés :**

1. **Réponse impulsionnelle :**  
   - Simulation d'une impulsion en entrée pour observer la réponse du filtre.

2. **Réponse à un signal sinusoïdal :**  
   - Simulation avec un signal sinusoïdal de fréquence constante généré sous MATLAB.

3. **Réponse à un signal chirp :**  
   - Simulation avec un signal chirp variant de `100 kHz` à `900 kHz`, généré sous MATLAB.

### **Exécution de la simulation sous Vivado XSim**

#### **Étapes pour simuler le filtre FIR :**

1. Ouvrir Vivado 2023.2 et lancer la simulation en ligne de commande :

2. Utiliser les fichiers de données générés sous MATLAB pour injecter des stimuli :

## **Détails des fichiers du projet**

- **`fir_parallel_16.vhd`** : Implémentation du filtre FIR parallèle en VHDL.
- **`fir_parallel_16_tb.vhd`** : Banc de test pour la validation du filtre (branche simulation).
- **`stimuleSignalFreqCst.m`** : Fichier qui contient le code pour généré le signal de test sinusoïdal à fréquence constante (branche simulation).
- **`stimuleFreqVar.m`** : Fichier de test pour le signal chirp (branche simulation).


## **Licence**

Ce projet est sous licence MIT - voir le fichier `LICENSE` pour plus d'informations.
