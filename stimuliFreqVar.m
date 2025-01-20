% -----------------------------------------------------------------------------
% Script de génération d'un signal chirp pour le test du filtre FIR parallèle
%
% Description :
% Ce script génère un signal chirp (dont la fréquence varie linéairement 
% dans le temps) afin de tester la réponse du filtre FIR à 16 coefficients.
% Le signal est échantillonné et sauvegardé dans un fichier texte, prêt 
% pour être utilisé comme entrée dans une simulation VHDL.
%
% Paramètres du signal :
% - Fréquence d'échantillonnage (Fs) : 3 MHz
% - Fréquence de départ (f_start)    : 100 kHz
% - Fréquence de fin (f_end)         : 900 kHz
% - Durée totale (T)                 : 200 µs
% - Amplitude minimale/maximale      : 8 à 120
% - Nom du fichier de sortie         : 'in.dat2'
%
% Auteur : DJOMO ELISABETH
% Date   : 26 - 01 - 2025
% -----------------------------------------------------------------------------

% -----------------------------------------------------------------------------
% Définition des paramètres
% -----------------------------------------------------------------------------
Fs = 3e6;              % Fréquence d'échantillonnage en Hz (3 MHz)
f_start = 100000;      % Fréquence initiale du chirp en Hz (100 kHz)
f_end = 900000;        % Fréquence finale du chirp en Hz (900 kHz)
T = 200e-6;            % Durée totale du signal en secondes (200 µs)
N = T * Fs;            % Nombre total d'échantillons basé sur la durée et Fs
amplitude_min = 8;     % Amplitude minimale du signal chirp
amplitude_max = 120;   % Amplitude maximale du signal chirp
filename = 'in.dat2';  % Nom du fichier de sortie contenant le signal généré

% -----------------------------------------------------------------------------
% Génération du signal chirp
% -----------------------------------------------------------------------------

t = (0:N-1) / Fs;        % Génération de l'axe temporel (en secondes)

% Calcul du taux de variation de la fréquence (balayage en fréquence)
k = (f_end - f_start) / T;   % Variation linéaire de fréquence (Hz/s)

% Calcul de la fréquence instantanée du chirp
instantaneous_frequency = f_start + k * t;  

% Calcul de la phase du signal chirp
phase = 2 * pi * cumsum(instantaneous_frequency) / Fs; 

% Génération du signal chirp normalisé entre -1 et 1
chirp_signal = sin(phase); 

% Mise à l'échelle du signal pour l'adapter à la plage d'amplitude spécifiée
amplitude = (amplitude_max - amplitude_min) / 2;  % Demi-amplitude
offset = (amplitude_max + amplitude_min) / 2;     % Décalage pour centrer
chirp_signal_scaled = round(amplitude * chirp_signal + offset);  % Mise à l'échelle

% -----------------------------------------------------------------------------
% Écriture du signal chirp dans un fichier texte pour utilisation en VHDL
% -----------------------------------------------------------------------------

fileID = fopen(filename, 'w');   % Ouvrir le fichier pour écriture
fprintf(fileID, '%d\n', chirp_signal_scaled);  % Écrire chaque valeur sur une nouvelle ligne
fclose(fileID);   % Fermer le fichier après écriture

disp(['Fichier "', filename, '" généré avec succès.']);

% -----------------------------------------------------------------------------
% Visualisation du signal chirp généré
% -----------------------------------------------------------------------------

figure;
plot(t * 1e3, chirp_signal_scaled, 'b'); % Tracé du signal, temps en millisecondes
title('Signal Chirp (Amplitude entre 8 et 120)');
xlabel('Temps (ms)');
ylabel('Amplitude');
grid on;
