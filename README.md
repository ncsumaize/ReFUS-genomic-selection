# ReFUS-genomic-selection
Scripts to get from multiplexed sequencing reads to GEBVs and selected individuals via genomic selection in ReFUS population

Step 1. Get fastseq files transferred to a folder inside RedRep directory on Linux machine. Rename the .fastq files to fit pipeline.sh script:
filename = data<lib>_<index>.fastq | meta<lib>_<index>.txt

Example: data1-2.fastq

Step 2. Create meta-data files with matching names with information on the individuals within each sequencing library:

Example meta1-2.txt

Files MUST have these columns:  
unique_id	library_id	person	date_submit	date_return	gbs_protocol	illumina_type	entry	p1_enzyme	p1_recog_site	p1_hang_seq	p1_index	p1_index_seq	p1_expect_seq	p2_enzyme	p2_recog_sit	p2_hang_seq	p2_index	p2_index_seq	p2_expect_seq	comment  
i01_17FL0107-10_i06	ReFUSC4_1	Josie_Bloom	3/20/2018	4/4/2018	RW-Lab	HiSeq2500	17FL0107-10	Csp6I	GTAC	C	Pi01	AACAATA	AACAATAC	NgoMIV	GCCGGC	C	Pi06	N/A	N/A	N/A  
i09_17FL0107-11_i06	ReFUSC4_1	Josie_Bloom	3/20/2018	4/4/2018	RW-Lab	HiSeq2500	17FL0107-11	Csp6I	GTAC	C	Pi09	CCACCTA	CCACCTAC	NgoMIV	GCCGGC	C	Pi06	N/A	N/A	N/A  
i10_17FL0107-12_i06	ReFUSC4_1	Josie_Bloom	3/20/2018	4/4/2018	RW-Lab	HiSeq2500	17FL0107-12	Csp6I	GTAC	C	Pi10	TTGTTTA	TTGTTTAC	NgoMIV	GCCGGC	C	Pi06	N/A	N/A	N/A  

[An example of a grid layout of DNA samples in 96-well plate format](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/ReFUS%20C4%20NGS%20Library%20plate%20layout.csv)

[Here is a python script to generate metadata files based on grid layout file](https://github.com/ncsumaize/ReFUS-genomic-selection/blob/master/Reformat%20plate%20layouts%20to%20metadata%20files%20for%20RedRep.py)  

Step 3. Run the RedRep pipeline:

[Publication by Manching et al. 2017](http://www.g3journal.org/content/7/7/2161)  
[RedRep GitHub page](https://github.com/UD-CBCB/RedRep)
