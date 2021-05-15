import numpy as np
from scipy.signal import stft,istft
from scipy.io.wavfile import read,write
import matplotlib.pyplot as plt

tme,freq=0,0

def show(pos,title,mat):
	plt.subplot(pos)
	img=plt.pcolormesh(tme,freq,np.log(mat+1e-10),vmin=0,vmax=10,shading='auto')
	plt.title(title)
	plt.colorbar(img,label='Energy(dB)')
	plt.ylabel('Frequency [Hz]')
	plt.xlabel('Time [sec]')

def sub_spec(spec,samp,min_energy=0):
	# gate=100
	# tmp=spec
	# tmp[tmp<gate]=0
	# return tmp
	ang=np.angle(spec)
	energy=np.abs(spec)**2
	# energy[energy<gate]=0
	energy-=samp
	energy=np.maximum(energy,min_energy*samp)**0.5
	return energy*np.exp(1j*ang)

frame_rate,estimated_audio=read('estimated.wav')
_,clean_audio=read('clean.wav')
_,mixture_audio=read('mixture.wav')
_,ideal_audio=read('ideal.wav')

full_sec=len(estimated_audio)/frame_rate
sec_per_frame=0.05
len_frame=int(sec_per_frame*frame_rate)
overlap_ratio=0.8
silent_sec=0.1

freq,tme,estimated_gram=stft(estimated_audio,nperseg=len_frame,noverlap=int(overlap_ratio*len_frame))
_,_,mixture_gram=stft(mixture_audio,nperseg=len_frame,noverlap=int(overlap_ratio*len_frame))
_,_,clean_gram=stft(clean_audio,nperseg=len_frame,noverlap=int(overlap_ratio*len_frame))
_,_,ideal_gram=stft(ideal_audio,nperseg=len_frame,noverlap=int(overlap_ratio*len_frame))
freq*=frame_rate
tme=np.linspace(0,full_sec,len(tme))


show(231,'Clean',np.abs(clean_gram))
show(232,'Mixture',np.abs(mixture_gram))
silent_frames=int((silent_sec-sec_per_frame)/(sec_per_frame*(1-overlap_ratio)))+1
print(silent_frames)
samp=(np.abs(mixture_gram)[:,:silent_frames].mean(axis=1,keepdims=True))**2
sub_gram=sub_spec(mixture_gram,samp)
show(233,'Sub Spec',np.abs(sub_gram))

show(234,'Ideal',np.abs(ideal_gram))
show(235,'Estimated',np.abs(estimated_gram))
sub_estimated=sub_spec(estimated_gram,samp)
show(236,'Sub Estimated',np.abs(sub_estimated))
plt.show()

sub_audio=istft(sub_gram,nperseg=len_frame,noverlap=int(overlap_ratio*len_frame))[1].astype('int16')
write('sub.wav',frame_rate,sub_audio)
sub_estimated_audio=istft(sub_estimated,nperseg=len_frame,noverlap=int(overlap_ratio*len_frame))[1].astype('int16')
write('sub_estimated.wav',frame_rate,sub_estimated_audio)