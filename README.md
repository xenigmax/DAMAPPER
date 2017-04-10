`run.sh` will produce `.bam` file using DAMAPPER.

This version of DAMAPPER supports 2 more options.
> -o<temporary_directory>, -l<path_to_daligner>

I didn't touch the other parts. However, you can try this version with your own risk.

Prerequisites
-------------
1) DALIGNER : https://github.com/thegenemyers/DALIGNER
2) DAZZ_DB : https://github.com/thegenemyers/DAZZ_DB
3) LASTOOLS : https://github.com/gt1/lastools

Please install above packages.

Setup
-----
1) Modify ["configuration"](https://github.com/xenigmax/DAMAPPER/blob/master/run.sh#L6-L21) part of `run.sh` according to your environment.
2) Make `ref.dam` from `ref.fasta` using fasta2DAM and DBsplit. You can refer [this](https://dazzlerblog.wordpress.com/command-guides/dazz_db-command-guide/) blog article.

Run
---
run.sh [ref.dam] [ref.fasta] [read.fasta] [out_dir]
