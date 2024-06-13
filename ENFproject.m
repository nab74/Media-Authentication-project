%%%%% step 2: test your function on a single audio 

for f=[60,120,180,240]
    x=transpose(audioread('recording1.wav'));
    Fs=44100;
    BlockSize=Fs*16;
    zeropad=0;
    Overlap=0.5;
    Window=hanning(BlockSize,'periodic');
    frequencies=f;

    [ENF1, ~, ~] = enf(x, Fs, BlockSize, zeropad, Overlap, Window, frequencies);
    [row,col]=size(ENF1);
    f1=frequencies-1;
    f2=frequencies+1;
    factor=(f2-f1)/col;
    x1=f1:factor:(f2-factor);
    y1=1:row;

    surf(x1,y1,ENF1);
    title('Magnitude Response for %dHz Signal',f);
    xlabel('Frequency (Hz)'); ylabel('Block Number');
    figure;
end

%%%%% Step 3: Compare two ENFs (no preprocessing)
audio1=transpose(audioread('recording1.wav'));
audio2=transpose(audioread('ground truth1.wav'));
Fs=44100;
BlockSize=Fs*16;
zeropad=0;
Overlap=0.5;
Window=hanning(BlockSize,'periodic');
frequencies=120;
f1=frequencies-1;
f2=frequencies+1;

% audio1 plot
[a1, a2, a3] = enf(audio1, Fs, BlockSize, zeropad, Overlap, Window, frequencies);
[row_a,col_a]=size(a1);
factor_a=(f2-f1)/col_a;
x1_a=f1:factor_a:(f2-factor_a);
y1_a=1:row_a;

surf(x1_a,y1_a,a1);
title("Audio 1 plot 'recording1.wav'");
xlabel('Frequency (Hz)'); ylabel('Block Number');
figure;

% audio2 plot
[b1, b2, b3] = enf(audio2, Fs, BlockSize, zeropad, Overlap, Window, frequencies);
[row_b,col_b]=size(b1);
factor_b=(f2-f1)/col_b;
x1_b=f1:factor_b:(f2-factor_b);
y1_b=1:row_b;

surf(x1_b,y1_b,b1);
title("Audio 2 plot'ground truth1.wav'");
xlabel('Frequency (Hz)'); ylabel('Block Number');
figure;

% subtract the mean from both weighted energies
a_enf=a3-mean(a3);
b_enf=b3-mean(b3);

% xcorr to find delay
[xc,delay]=xcorr(a_enf,b_enf);
plot(delay,xc);
title("cross Correlation Plot");
xlabel('Delay (secs)');ylabel('Cross-correlation');
figure;

% Plot  both weighted energies before alignment
plot(a3);
hold on;
plot(b3);
title("Pre-aligned Weighted Response of 'recording1.wav' & 'ground truth1.wav'");
figure;

% Plot both weighted energies after alignment
align_a=padarray(a3,2,mean(a3));
align_b=padarray(b3,2,mean(b3));

plot(align_a);
hold on;
plot(align_b);
title("Aligned Weighted Response of 'recording1.wav' & 'ground truth1.wav'");
figure;

%%%%% Step 4: Compare two ENFs (with preprocessing)
Fs=441;
zeropad=(2^14)-(Fs*16);

BlockSize=Fs*16;
Overlap=0.5;
Window=hanning(BlockSize,'periodic');
frequencies=120;
f1=frequencies-1;
f2=frequencies+1;

load('SOS.mat');
load('G.mat');

audio1_process=downsample(filtfilt(SOS,G,audio1),100);
audio2_process=downsample(filtfilt(SOS,G,audio2),100);

[c1, c2, c3] = enf(audio1_process, Fs, BlockSize, zeropad, Overlap, Window, frequencies);
[row_c,col_c]=size(c1);
factor_c=(f2-f1)/col_c;
x1_c=f1:factor_c:(f2-factor_c);
y1_c=1:row_c;
surf(x1_c,y1_c,c1);
title("Audio 1 plot 'recording1.wav' with pre-processing");
xlabel('Frequency (Hz)'); ylabel('Block Number');
figure;

[d1, d2, d3] = enf(audio2_process, Fs, BlockSize, zeropad, Overlap, Window, frequencies);
[row_d,col_d]=size(d1);
factor_d=(f2-f1)/col_d;
x1_d=f1:factor_d:(f2-factor_d);
y1_d=1:row_d;
surf(x1_d,y1_d,d1);
title("Audio 1 plot 'ground truth1.wav' with pre-processing");
xlabel('Frequency (Hz)'); ylabel('Block Number');
figure;

%subtract the mean from both weighted energies
c_enf=c3-mean(c3);
d_enf=d3-mean(d3);

%use xcorr to find delay
[xc,delay]=xcorr(c_enf,d_enf);
plot(delay,xc);
title("Cross Correlation Plot for Pre-processing");
xlabel('Delay (secs)');ylabel('Cross-correlation');
figure;

%Plot both weighted energies after allignment
align_c=padarray(c3,2,mean(c3));
align_d=padarray(d3,2,mean(d3));

plot(align_c);
hold on;
plot(align_d);
title("Aligned Weighted Response of 'recording1.wav' & " + ...
    "'ground truth1.wav' with Pre-processing");
figure;

%%%%% Step 5: Compare second set of signals (with preprocessing)
audio3=transpose(audioread('recording 21.wav'));
audio4=transpose(audioread('ground truth 21.wav'));

audio3_process=downsample(filtfilt(SOS,G,audio3),100);
audio4_process=downsample(filtfilt(SOS,G,audio4),100);

[e1, e2, e3] = enf(audio3_process, Fs, BlockSize, zeropad, Overlap, Window, frequencies);
[row_e,col_e]=size(e1);
factor_e=(f2-f1)/col_e;
x1_e=f1:factor_e:(f2-factor_e);
y1_e=1:row_e;
surf(x1_e,y1_e,e1);
title("Audio 1 plot 'recording 21.wav' with pre-processing");
xlabel('Frequency (Hz)'); ylabel('Block Number');
figure;

[g1, g2, g3] = enf(audio4_process, Fs, BlockSize, zeropad, Overlap, Window, frequencies);
[row_g,col_g]=size(g1);
factor_g=(f2-f1)/col_g;
x1_g=f1:factor_g:(f2-factor_g);
y1_g=1:row_g;
surf(x1_g,y1_g,g1);
title("Audio 1 plot 'ground truth 21.wav' with pre-processing");
xlabel('Frequency (Hz)'); ylabel('Block Number');
figure;

%subtract the mean from both weighted energies
e_enf=e3-mean(e3);
g_enf=g3-mean(g3);


%use xcorr to find delay
[xc,delay]=xcorr(e_enf,g_enf);
plot(delay,xc);
title("Second set Cross Correlation Plot for Pre-processing");
xlabel('Delay (secs)');ylabel('Cross-correlation');
figure;

%Plot both weighted energies after allignment
align_e=padarray(e3,2,mean(e3));
align_g=padarray(g3,2,mean(g3));

plot(align_e);
hold on;
plot(align_g);
title("Aligned Weighted Response of 'recording 21.wav' & " + ...
    "'ground truth 21.wav' with Pre-processing");
figure;
