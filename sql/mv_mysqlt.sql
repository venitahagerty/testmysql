-- data_file_type_lu is a look-up table containing information about the different types
--   of MET output data files.  Each data file that is loaded into the DATABASE is
--   represented by a record in the data_file table, which points at one of the data file
--   types.  The file type indicates which DATABASE tables store the data in the file.

DROP TABLE IF EXISTS data_file_lu;
CREATE TABLE data_file_lu
(
    data_file_lu_id INT UNSIGNED NOT NULL,
    type_name       VARCHAR(32),
    type_desc       VARCHAR(128),
    PRIMARY KEY (data_file_lu_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- data_file_id stores information about files that have been parsed and loaded into the
--   DATABASE.  Each record represents a single file of a particular MET output data file
--   type (point_stat, mode, etc.).  Each data_file record points at its file type in the
--   data_file_type_lu table via the data_file_type_lu_id field.

DROP TABLE IF EXISTS data_file;
CREATE TABLE data_file
(
    data_file_id    INT UNSIGNED NOT NULL,
    data_file_lu_id INT UNSIGNED NOT NULL,
    filename        VARCHAR(110),
    path            VARCHAR(120),
    load_date       DATETIME,
    mod_date        DATETIME,
    PRIMARY KEY (data_file_id),
    CONSTRAINT data_file_unique_pk
        UNIQUE INDEX (filename, path),
    CONSTRAINT stat_header_data_file_lu_id_pk
        FOREIGN KEY (data_file_lu_id)
            REFERENCES data_file_lu (data_file_lu_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- stat_header contains the forecast and observation bookkeeping information, except for
--   the valid and init times, for a verification case.  Statistics tables point at a
--   single stat_header record, which indicate the circumstances under which they were
--   calculated.

DROP TABLE IF EXISTS stat_header;
CREATE TABLE stat_header
(
    stat_header_id INT UNSIGNED NOT NULL,
    version        VARCHAR(8),
    model          VARCHAR(40),
    descr          VARCHAR(40)  DEFAULT 'NA',
    fcst_var       VARCHAR(50),
    fcst_units     VARCHAR(100) DEFAULT 'NA',
    fcst_lev       VARCHAR(100),
    obs_var        VARCHAR(50),
    obs_units      VARCHAR(100) DEFAULT 'NA',
    obs_lev        VARCHAR(100),
    obtype         VARCHAR(20),
    vx_mask        VARCHAR(100),
    interp_mthd    VARCHAR(20),
    interp_pnts    INT UNSIGNED,
    fcst_thresh    VARCHAR(100),
    obs_thresh     VARCHAR(100),

    PRIMARY KEY (stat_header_id)


) ENGINE = MyISAM
  CHARACTER SET = latin1;
CREATE INDEX stat_header_unique_pk ON stat_header (
                                                   model,
                                                   fcst_var(20),
                                                   fcst_lev (10),
                                                   obs_var(20),
                                                   obs_lev(10),
                                                   obtype(10),
                                                   vx_mask(20),
                                                   interp_mthd,
                                                   interp_pnts,
                                                   fcst_thresh(20),
                                                   obs_thresh(20)
    );

-- line_data_fho contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_fho;
CREATE TABLE line_data_fho
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    f_rate         DOUBLE,
    h_rate         DOUBLE,
    o_rate         DOUBLE,

    CONSTRAINT line_data_fho_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_fho_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_ctc contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_ctc;
CREATE TABLE line_data_ctc
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    fy_oy          INT UNSIGNED,
    fy_on          INT UNSIGNED,
    fn_oy          INT UNSIGNED,
    fn_on          INT UNSIGNED,

    CONSTRAINT line_data_ctc_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_ctc_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_cts contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_cts;
CREATE TABLE line_data_cts
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    alpha          DOUBLE,
    total          INT UNSIGNED,

    baser          DOUBLE,
    baser_ncl      DOUBLE,
    baser_ncu      DOUBLE,
    baser_bcl      DOUBLE,
    baser_bcu      DOUBLE,
    fmean          DOUBLE,
    fmean_ncl      DOUBLE,
    fmean_ncu      DOUBLE,
    fmean_bcl      DOUBLE,
    fmean_bcu      DOUBLE,
    acc            DOUBLE,
    acc_ncl        DOUBLE,
    acc_ncu        DOUBLE,
    acc_bcl        DOUBLE,
    acc_bcu        DOUBLE,
    fbias          DOUBLE,
    fbias_bcl      DOUBLE,
    fbias_bcu      DOUBLE,
    pody           DOUBLE,
    pody_ncl       DOUBLE,
    pody_ncu       DOUBLE,
    pody_bcl       DOUBLE,
    pody_bcu       DOUBLE,
    podn           DOUBLE,
    podn_ncl       DOUBLE,
    podn_ncu       DOUBLE,
    podn_bcl       DOUBLE,
    podn_bcu       DOUBLE,
    pofd           DOUBLE,
    pofd_ncl       DOUBLE,
    pofd_ncu       DOUBLE,
    pofd_bcl       DOUBLE,
    pofd_bcu       DOUBLE,
    far            DOUBLE,
    far_ncl        DOUBLE,
    far_ncu        DOUBLE,
    far_bcl        DOUBLE,
    far_bcu        DOUBLE,
    csi            DOUBLE,
    csi_ncl        DOUBLE,
    csi_ncu        DOUBLE,
    csi_bcl        DOUBLE,
    csi_bcu        DOUBLE,
    gss            DOUBLE,
    gss_bcl        DOUBLE,
    gss_bcu        DOUBLE,
    hk             DOUBLE,
    hk_ncl         DOUBLE,
    hk_ncu         DOUBLE,
    hk_bcl         DOUBLE,
    hk_bcu         DOUBLE,
    hss            DOUBLE,
    hss_bcl        DOUBLE,
    hss_bcu        DOUBLE,
    odds           DOUBLE,
    odds_ncl       DOUBLE,
    odds_ncu       DOUBLE,
    odds_bcl       DOUBLE,
    odds_bcu       DOUBLE,

    lodds          DOUBLE DEFAULT -9999,
    lodds_ncl      DOUBLE DEFAULT -9999,
    lodds_ncu      DOUBLE DEFAULT -9999,
    lodds_bcl      DOUBLE DEFAULT -9999,
    lodds_bcu      DOUBLE DEFAULT -9999,

    orss           DOUBLE DEFAULT -9999,
    orss_ncl       DOUBLE DEFAULT -9999,
    orss_ncu       DOUBLE DEFAULT -9999,
    orss_bcl       DOUBLE DEFAULT -9999,
    orss_bcu       DOUBLE DEFAULT -9999,

    eds            DOUBLE DEFAULT -9999,
    eds_ncl        DOUBLE DEFAULT -9999,
    eds_ncu        DOUBLE DEFAULT -9999,
    eds_bcl        DOUBLE DEFAULT -9999,
    eds_bcu        DOUBLE DEFAULT -9999,

    seds           DOUBLE DEFAULT -9999,
    seds_ncl       DOUBLE DEFAULT -9999,
    seds_ncu       DOUBLE DEFAULT -9999,
    seds_bcl       DOUBLE DEFAULT -9999,
    seds_bcu       DOUBLE DEFAULT -9999,

    edi            DOUBLE DEFAULT -9999,
    edi_ncl        DOUBLE DEFAULT -9999,
    edi_ncu        DOUBLE DEFAULT -9999,
    edi_bcl        DOUBLE DEFAULT -9999,
    edi_bcu        DOUBLE DEFAULT -9999,

    sedi           DOUBLE DEFAULT -9999,
    sedi_ncl       DOUBLE DEFAULT -9999,
    sedi_ncu       DOUBLE DEFAULT -9999,
    sedi_bcl       DOUBLE DEFAULT -9999,
    sedi_bcu       DOUBLE DEFAULT -9999,

    bagss          DOUBLE DEFAULT -9999,
    bagss_bcl      DOUBLE DEFAULT -9999,
    bagss_bcu      DOUBLE DEFAULT -9999,

    CONSTRAINT line_data_cts_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_cts_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;
-- CREATE INDEX line_data_cts_fcst_lead_pk ON line_data_cts (fcst_lead);
-- CREATE INDEX line_data_cts_fcst_valid_beg_pk ON line_data_cts (fcst_valid_beg);
-- CREATE INDEX line_data_cts_fcst_init_beg_pk ON line_data_cts (fcst_init_beg);


-- line_data_cnt contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_cnt;
CREATE TABLE line_data_cnt
(
    stat_header_id       INT UNSIGNED NOT NULL,
    data_file_id         INT UNSIGNED NOT NULL,
    line_num             INT UNSIGNED,
    fcst_lead            INT,
    fcst_valid_beg       DATETIME,
    fcst_valid_end       DATETIME,
    fcst_init_beg        DATETIME,
    obs_lead             INT UNSIGNED,
    obs_valid_beg        DATETIME,
    obs_valid_end        DATETIME,
    alpha                DOUBLE,
    total                INT UNSIGNED,
    fbar                 DOUBLE,
    fbar_ncl             DOUBLE,
    fbar_ncu             DOUBLE,
    fbar_bcl             DOUBLE,
    fbar_bcu             DOUBLE,
    fstdev               DOUBLE,
    fstdev_ncl           DOUBLE,
    fstdev_ncu           DOUBLE,
    fstdev_bcl           DOUBLE,
    fstdev_bcu           DOUBLE,
    obar                 DOUBLE,
    obar_ncl             DOUBLE,
    obar_ncu             DOUBLE,
    obar_bcl             DOUBLE,
    obar_bcu             DOUBLE,
    ostdev               DOUBLE,
    ostdev_ncl           DOUBLE,
    ostdev_ncu           DOUBLE,
    ostdev_bcl           DOUBLE,
    ostdev_bcu           DOUBLE,
    pr_corr              DOUBLE,
    pr_corr_ncl          DOUBLE,
    pr_corr_ncu          DOUBLE,
    pr_corr_bcl          DOUBLE,
    pr_corr_bcu          DOUBLE,
    sp_corr              DOUBLE,
    dt_corr              DOUBLE,
    ranks                INT UNSIGNED,
    frank_ties           INT,
    orank_ties           INT,
    me                   DOUBLE,
    me_ncl               DOUBLE,
    me_ncu               DOUBLE,
    me_bcl               DOUBLE,
    me_bcu               DOUBLE,
    estdev               DOUBLE,
    estdev_ncl           DOUBLE,
    estdev_ncu           DOUBLE,
    estdev_bcl           DOUBLE,
    estdev_bcu           DOUBLE,
    mbias                DOUBLE,
    mbias_bcl            DOUBLE,
    mbias_bcu            DOUBLE,
    mae                  DOUBLE,
    mae_bcl              DOUBLE,
    mae_bcu              DOUBLE,
    mse                  DOUBLE,
    mse_bcl              DOUBLE,
    mse_bcu              DOUBLE,
    bcmse                DOUBLE,
    bcmse_bcl            DOUBLE,
    bcmse_bcu            DOUBLE,
    rmse                 DOUBLE,
    rmse_bcl             DOUBLE,
    rmse_bcu             DOUBLE,
    e10                  DOUBLE,
    e10_bcl              DOUBLE,
    e10_bcu              DOUBLE,
    e25                  DOUBLE,
    e25_bcl              DOUBLE,
    e25_bcu              DOUBLE,
    e50                  DOUBLE,
    e50_bcl              DOUBLE,
    e50_bcu              DOUBLE,
    e75                  DOUBLE,
    e75_bcl              DOUBLE,
    e75_bcu              DOUBLE,
    e90                  DOUBLE,
    e90_bcl              DOUBLE,
    e90_bcu              DOUBLE,
    iqr                  DOUBLE DEFAULT -9999,
    iqr_bcl              DOUBLE DEFAULT -9999,
    iqr_bcu              DOUBLE DEFAULT -9999,
    mad                  DOUBLE DEFAULT -9999,
    mad_bcl              DOUBLE DEFAULT -9999,
    mad_bcu              DOUBLE DEFAULT -9999,
    anom_corr            DOUBLE DEFAULT -9999,
    anom_corr_ncl        DOUBLE DEFAULT -9999,
    anom_corr_ncu        DOUBLE DEFAULT -9999,
    anom_corr_bcl        DOUBLE DEFAULT -9999,
    anom_corr_bcu        DOUBLE DEFAULT -9999,

    me2                  DOUBLE DEFAULT -9999,
    me2_bcl              DOUBLE DEFAULT -9999,
    me2_bcu              DOUBLE DEFAULT -9999,
    msess                DOUBLE DEFAULT -9999,
    msess_bcl            DOUBLE DEFAULT -9999,
    msess_bcu            DOUBLE DEFAULT -9999,
    rmsfa                DOUBLE DEFAULT -9999,
    rmsfa_bcl            DOUBLE DEFAULT -9999,
    rmsfa_bcu            DOUBLE DEFAULT -9999,
    rmsoa                DOUBLE DEFAULT -9999,
    rmsoa_bcl            DOUBLE DEFAULT -9999,
    rmsoa_bcu            DOUBLE DEFAULT -9999,

    anom_corr_uncntr     DOUBLE DEFAULT -9999,
    anom_corr_uncntr_bcl DOUBLE DEFAULT -9999,
    anom_corr_uncntr_bcu DOUBLE DEFAULT -9999,


    CONSTRAINT line_data_cnt_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_cnt_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_ecnt contains stat data for a Continuous Ensemble Statistics.

DROP TABLE IF EXISTS line_data_ecnt;
CREATE TABLE line_data_ecnt
(
    stat_header_id   INT UNSIGNED NOT NULL,
    data_file_id     INT UNSIGNED NOT NULL,
    line_num         INT UNSIGNED,
    fcst_lead        INT,
    fcst_valid_beg   DATETIME,
    fcst_valid_end   DATETIME,
    fcst_init_beg    DATETIME,
    obs_lead         INT UNSIGNED,
    obs_valid_beg    DATETIME,
    obs_valid_end    DATETIME,

    total            INT UNSIGNED,
    n_ens            INT,
    crps             DOUBLE,
    crpss            DOUBLE,
    ign              DOUBLE,
    me               DOUBLE,
    rmse             DOUBLE,
    spread           DOUBLE,
    me_oerr          DOUBLE,
    rmse_oerr        DOUBLE,
    spread_oerr      DOUBLE,
    spread_plus_oerr DOUBLE,

    crpscl           DOUBLE,
    crps_emp         DOUBLE,
    crpscl_emp       DOUBLE,
    crpss_emp        DOUBLE,

    CONSTRAINT line_data_ecnt_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_ecnt_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_mctc contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_mctc;
CREATE TABLE line_data_mctc
(
    line_data_id   INT UNSIGNED NOT NULL,
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,
    n_cat          INT UNSIGNED,

    PRIMARY KEY (line_data_id),
    CONSTRAINT line_data_mctc_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_mctc_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_mctc_cnt contains count data for a particular line_data_mctc record.  The
--   number of counts is determined by assuming a square contingency table and stored in
--   the line_data_mctc field n_cat.

DROP TABLE IF EXISTS line_data_mctc_cnt;
CREATE TABLE line_data_mctc_cnt
(
    line_data_id INT UNSIGNED NOT NULL,
    i_value      INT UNSIGNED NOT NULL,
    j_value      INT UNSIGNED NOT NULL,
    fi_oj        INT UNSIGNED NOT NULL,

    PRIMARY KEY (line_data_id, i_value, j_value)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_mcts contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_mcts;
CREATE TABLE line_data_mcts
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    alpha          DOUBLE,
    total          INT UNSIGNED,
    n_cat          INT UNSIGNED,

    acc            DOUBLE,
    acc_ncl        DOUBLE,
    acc_ncu        DOUBLE,
    acc_bcl        DOUBLE,
    acc_bcu        DOUBLE,
    hk             DOUBLE,
    hk_bcl         DOUBLE,
    hk_bcu         DOUBLE,
    hss            DOUBLE,
    hss_bcl        DOUBLE,
    hss_bcu        DOUBLE,
    ger            DOUBLE,
    ger_bcl        DOUBLE,
    ger_bcu        DOUBLE,

    CONSTRAINT line_data_mcts_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_mcts_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_pct contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_pct;
CREATE TABLE line_data_pct
(
    line_data_id   INT UNSIGNED NOT NULL,
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    cov_thresh     VARCHAR(32),
    total          INT UNSIGNED,
    n_thresh       INT UNSIGNED,

    PRIMARY KEY (line_data_id),
    CONSTRAINT line_data_pct_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_pct_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_pct_thresh contains threshold data for a particular line_data_pct record and
--   threshold.  The number of thresholds stored is given by the line_data_pct field n_thresh.

DROP TABLE IF EXISTS line_data_pct_thresh;
CREATE TABLE line_data_pct_thresh
(
    line_data_id INT UNSIGNED NOT NULL,
    i_value      INT UNSIGNED NOT NULL,
    thresh_i     DOUBLE,
    oy_i         INT UNSIGNED,
    on_i         INT UNSIGNED,

    PRIMARY KEY (line_data_id, i_value)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_pstd contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_pstd;
CREATE TABLE line_data_pstd
(
    line_data_id   INT UNSIGNED NOT NULL,
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    cov_thresh     VARCHAR(32),
    alpha          DOUBLE,
    total          INT UNSIGNED,
    n_thresh       INT UNSIGNED,

    baser          DOUBLE,
    baser_ncl      DOUBLE,
    baser_ncu      DOUBLE,
    reliability    DOUBLE,
    resolution     DOUBLE,
    uncertainty    DOUBLE,
    roc_auc        DOUBLE,
    brier          DOUBLE,
    brier_ncl      DOUBLE,
    brier_ncu      DOUBLE,

    briercl        DOUBLE DEFAULT -9999,
    briercl_ncl    DOUBLE DEFAULT -9999,
    briercl_ncu    DOUBLE DEFAULT -9999,
    bss            DOUBLE DEFAULT -9999,
    bss_smpl       DOUBLE DEFAULT -9999,

    PRIMARY KEY (line_data_id),
    CONSTRAINT line_data_pstd_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_pstd_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_pstd_thresh contains threshold data for a particular line_data_pstd record and
--   threshold.  The number of thresholds stored is given by the line_data_pstd field n_thresh.

DROP TABLE IF EXISTS line_data_pstd_thresh;
CREATE TABLE line_data_pstd_thresh
(
    line_data_id INT UNSIGNED NOT NULL,
    i_value      INT UNSIGNED NOT NULL,
    thresh_i     DOUBLE,

    PRIMARY KEY (line_data_id, i_value)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_pjc contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_pjc;
CREATE TABLE line_data_pjc
(
    line_data_id   INT UNSIGNED NOT NULL,
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    cov_thresh     VARCHAR(32),
    total          INT UNSIGNED,
    n_thresh       INT UNSIGNED,

    PRIMARY KEY (line_data_id),
    CONSTRAINT line_data_pjc_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_pjc_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_pjc_thresh contains threshold data for a particular line_data_pjc record and
--   threshold.  The number of thresholds stored is given by the line_data_pjc field n_thresh.

DROP TABLE IF EXISTS line_data_pjc_thresh;
CREATE TABLE line_data_pjc_thresh
(
    line_data_id  INT UNSIGNED NOT NULL,
    i_value       INT UNSIGNED NOT NULL,
    thresh_i      DOUBLE,
    oy_tp_i       DOUBLE,
    on_tp_i       DOUBLE,
    calibration_i DOUBLE,
    refinement_i  DOUBLE,
    likelihood_i  DOUBLE,
    baser_i       DOUBLE,

    PRIMARY KEY (line_data_id, i_value)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_prc contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_prc;
CREATE TABLE line_data_prc
(
    line_data_id   INT UNSIGNED NOT NULL,
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    cov_thresh     VARCHAR(32),
    total          INT UNSIGNED,
    n_thresh       INT UNSIGNED,

    PRIMARY KEY (line_data_id),
    CONSTRAINT line_data_prc_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_prc_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_prc_thresh contains threshold data for a particular line_data_prc record and
--   threshold.  The number of thresholds stored is given by the line_data_prc field n_thresh.

DROP TABLE IF EXISTS line_data_prc_thresh;
CREATE TABLE line_data_prc_thresh
(
    line_data_id INT UNSIGNED NOT NULL,
    i_value      INT UNSIGNED NOT NULL,
    thresh_i     DOUBLE,
    pody_i       DOUBLE,
    pofd_i       DOUBLE,

    PRIMARY KEY (line_data_id, i_value)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_sl1l2 contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_sl1l2;
CREATE TABLE line_data_sl1l2
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    fbar           DOUBLE,
    obar           DOUBLE,
    fobar          DOUBLE,
    ffbar          DOUBLE,
    oobar          DOUBLE,
    mae            DOUBLE DEFAULT -9999,

    CONSTRAINT line_data_sl1l2_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_sl1l2_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

DROP TABLE IF EXISTS line_data_grad;
CREATE TABLE line_data_grad
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    fgbar          DOUBLE,
    ogbar          DOUBLE,
    mgbar          DOUBLE,
    egbar          DOUBLE,
    s1             DOUBLE,
    s1_og          DOUBLE DEFAULT -9999,
    fgog_ratio     DOUBLE DEFAULT -9999,
    dx             INT    DEFAULT -9999,
    dy             INT    DEFAULT -9999,

    CONSTRAINT line_data_grad_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_grad_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_sal1l2 contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_sal1l2;
CREATE TABLE line_data_sal1l2
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    fabar          DOUBLE,
    oabar          DOUBLE,
    foabar         DOUBLE,
    ffabar         DOUBLE,
    ooabar         DOUBLE,
    mae            DOUBLE DEFAULT -9999,

    CONSTRAINT line_data_sal2l1_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_sal2l1_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_vl1l2 contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_vl1l2;
CREATE TABLE line_data_vl1l2
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    ufbar          DOUBLE,
    vfbar          DOUBLE,
    uobar          DOUBLE,
    vobar          DOUBLE,
    uvfobar        DOUBLE,
    uvffbar        DOUBLE,
    uvoobar        DOUBLE,
    f_speed_bar    DOUBLE,
    o_speed_bar    DOUBLE,

    CONSTRAINT line_data_vl1l2_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_vl1l2_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_val1l2 contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_val1l2;
CREATE TABLE line_data_val1l2
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    ufabar         DOUBLE,
    vfabar         DOUBLE,
    uoabar         DOUBLE,
    voabar         DOUBLE,
    uvfoabar       DOUBLE,
    uvffabar       DOUBLE,
    uvooabar       DOUBLE,

    CONSTRAINT line_data_val1l2_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_val1l2_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_mpr contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_mpr;
CREATE TABLE line_data_mpr
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    mp_index       INT UNSIGNED,
    obs_sid        VARCHAR(32),
    obs_lat        DOUBLE,
    obs_lon        DOUBLE,
    obs_lvl        DOUBLE,
    obs_elv        DOUBLE,
    mpr_fcst       DOUBLE,
    mpr_obs        DOUBLE,
    mpr_climo      DOUBLE,
    obs_qc         VARCHAR(32),
    climo_mean     DOUBLE,
    climo_stdev    DOUBLE,
    climo_cdf      DOUBLE,

    CONSTRAINT line_data_mpr_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_mpr_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_nbrctc contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_nbrctc;
CREATE TABLE line_data_nbrctc
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    cov_thresh     VARCHAR(32),
    total          INT UNSIGNED,

    fy_oy          INT UNSIGNED,
    fy_on          INT UNSIGNED,
    fn_oy          INT UNSIGNED,
    fn_on          INT UNSIGNED,

    CONSTRAINT line_data_nbrctc_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_nbrctc_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_nbrcts contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_nbrcts;
CREATE TABLE line_data_nbrcts
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    cov_thresh     VARCHAR(32),
    alpha          DOUBLE,
    total          INT UNSIGNED,

    baser          DOUBLE,
    baser_ncl      DOUBLE,
    baser_ncu      DOUBLE,
    baser_bcl      DOUBLE,
    baser_bcu      DOUBLE,
    fmean          DOUBLE,
    fmean_ncl      DOUBLE,
    fmean_ncu      DOUBLE,
    fmean_bcl      DOUBLE,
    fmean_bcu      DOUBLE,
    acc            DOUBLE,
    acc_ncl        DOUBLE,
    acc_ncu        DOUBLE,
    acc_bcl        DOUBLE,
    acc_bcu        DOUBLE,
    fbias          DOUBLE,
    fbias_bcl      DOUBLE,
    fbias_bcu      DOUBLE,
    pody           DOUBLE,
    pody_ncl       DOUBLE,
    pody_ncu       DOUBLE,
    pody_bcl       DOUBLE,
    pody_bcu       DOUBLE,
    podn           DOUBLE,
    podn_ncl       DOUBLE,
    podn_ncu       DOUBLE,
    podn_bcl       DOUBLE,
    podn_bcu       DOUBLE,
    pofd           DOUBLE,
    pofd_ncl       DOUBLE,
    pofd_ncu       DOUBLE,
    pofd_bcl       DOUBLE,
    pofd_bcu       DOUBLE,
    far            DOUBLE,
    far_ncl        DOUBLE,
    far_ncu        DOUBLE,
    far_bcl        DOUBLE,
    far_bcu        DOUBLE,
    csi            DOUBLE,
    csi_ncl        DOUBLE,
    csi_ncu        DOUBLE,
    csi_bcl        DOUBLE,
    csi_bcu        DOUBLE,
    gss            DOUBLE,
    gss_bcl        DOUBLE,
    gss_bcu        DOUBLE,
    hk             DOUBLE,
    hk_ncl         DOUBLE,
    hk_ncu         DOUBLE,
    hk_bcl         DOUBLE,
    hk_bcu         DOUBLE,
    hss            DOUBLE,
    hss_bcl        DOUBLE,
    hss_bcu        DOUBLE,
    odds           DOUBLE,
    odds_ncl       DOUBLE,
    odds_ncu       DOUBLE,
    odds_bcl       DOUBLE,
    odds_bcu       DOUBLE,

    lodds          DOUBLE DEFAULT -9999,
    lodds_ncl      DOUBLE DEFAULT -9999,
    lodds_ncu      DOUBLE DEFAULT -9999,
    lodds_bcl      DOUBLE DEFAULT -9999,
    lodds_bcu      DOUBLE DEFAULT -9999,

    orss           DOUBLE DEFAULT -9999,
    orss_ncl       DOUBLE DEFAULT -9999,
    orss_ncu       DOUBLE DEFAULT -9999,
    orss_bcl       DOUBLE DEFAULT -9999,
    orss_bcu       DOUBLE DEFAULT -9999,

    eds            DOUBLE DEFAULT -9999,
    eds_ncl        DOUBLE DEFAULT -9999,
    eds_ncu        DOUBLE DEFAULT -9999,
    eds_bcl        DOUBLE DEFAULT -9999,
    eds_bcu        DOUBLE DEFAULT -9999,

    seds           DOUBLE DEFAULT -9999,
    seds_ncl       DOUBLE DEFAULT -9999,
    seds_ncu       DOUBLE DEFAULT -9999,
    seds_bcl       DOUBLE DEFAULT -9999,
    seds_bcu       DOUBLE DEFAULT -9999,

    edi            DOUBLE DEFAULT -9999,
    edi_ncl        DOUBLE DEFAULT -9999,
    edi_ncu        DOUBLE DEFAULT -9999,
    edi_bcl        DOUBLE DEFAULT -9999,
    edi_bcu        DOUBLE DEFAULT -9999,

    sedi           DOUBLE DEFAULT -9999,
    sedi_ncl       DOUBLE DEFAULT -9999,
    sedi_ncu       DOUBLE DEFAULT -9999,
    sedi_bcl       DOUBLE DEFAULT -9999,
    sedi_bcu       DOUBLE DEFAULT -9999,

    bagss          DOUBLE DEFAULT -9999,
    bagss_bcl      DOUBLE DEFAULT -9999,
    bagss_bcu      DOUBLE DEFAULT -9999,

    CONSTRAINT line_data_nbrcts_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_nbrcts_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_nbrcnt contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_nbrcnt;
CREATE TABLE line_data_nbrcnt
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    alpha          DOUBLE,
    total          INT UNSIGNED,

    fbs            DOUBLE,
    fbs_bcl        DOUBLE,
    fbs_bcu        DOUBLE,
    fss            DOUBLE,
    fss_bcl        DOUBLE,
    fss_bcu        DOUBLE,
    afss           DOUBLE DEFAULT -9999,
    afss_bcl       DOUBLE DEFAULT -9999,
    afss_bcu       DOUBLE DEFAULT -9999,
    ufss           DOUBLE DEFAULT -9999,
    ufss_bcl       DOUBLE DEFAULT -9999,
    ufss_bcu       DOUBLE DEFAULT -9999,
    f_rate         DOUBLE DEFAULT -9999,
    f_rate_bcl     DOUBLE DEFAULT -9999,
    f_rate_bcu     DOUBLE DEFAULT -9999,
    o_rate         DOUBLE DEFAULT -9999,
    o_rate_bcl     DOUBLE DEFAULT -9999,
    o_rate_bcu     DOUBLE DEFAULT -9999,


    CONSTRAINT line_data_nbrcnt_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_nbrcnt_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

DROP TABLE IF EXISTS line_data_enscnt;
CREATE TABLE line_data_enscnt
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT UNSIGNED,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,

    rpsf           DOUBLE DEFAULT -9999,
    rpsf_ncl       DOUBLE DEFAULT -9999,
    rpsf_ncu       DOUBLE DEFAULT -9999,
    rpsf_bcl       DOUBLE DEFAULT -9999,
    rpsf_bcu       DOUBLE DEFAULT -9999,

    rpscl          DOUBLE DEFAULT -9999,
    rpscl_ncl      DOUBLE DEFAULT -9999,
    rpscl_ncu      DOUBLE DEFAULT -9999,
    rpscl_bcl      DOUBLE DEFAULT -9999,
    rpscl_bcu      DOUBLE DEFAULT -9999,

    rpss           DOUBLE DEFAULT -9999,
    rpss_ncl       DOUBLE DEFAULT -9999,
    rpss_ncu       DOUBLE DEFAULT -9999,
    rpss_bcl       DOUBLE DEFAULT -9999,
    rpss_bcu       DOUBLE DEFAULT -9999,

    crpsf          DOUBLE DEFAULT -9999,
    crpsf_ncl      DOUBLE DEFAULT -9999,
    crpsf_ncu      DOUBLE DEFAULT -9999,
    crpsf_bcl      DOUBLE DEFAULT -9999,
    crpsf_bcu      DOUBLE DEFAULT -9999,

    crpscl         DOUBLE DEFAULT -9999,
    crpscl_ncl     DOUBLE DEFAULT -9999,
    crpscl_ncu     DOUBLE DEFAULT -9999,
    crpscl_bcl     DOUBLE DEFAULT -9999,
    crpscl_bcu     DOUBLE DEFAULT -9999,

    crpss          DOUBLE DEFAULT -9999,
    crpss_ncl      DOUBLE DEFAULT -9999,
    crpss_ncu      DOUBLE DEFAULT -9999,
    crpss_bcl      DOUBLE DEFAULT -9999,
    crpss_bcu      DOUBLE DEFAULT -9999,


    CONSTRAINT line_data_enscnt_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_enscnt_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

--  contains stat data for a particular stat_header record, which it points
--    at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_isc;
CREATE TABLE line_data_isc
(
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    tile_dim       DOUBLE,
    time_xll       DOUBLE,
    tile_yll       DOUBLE,
    nscale         DOUBLE,
    iscale         DOUBLE,
    mse            DOUBLE,
    isc            DOUBLE,
    fenergy2       DOUBLE,
    oenergy2       DOUBLE,
    baser          DOUBLE,
    fbias          DOUBLE,

    CONSTRAINT line_data_isc_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_isc_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_rhist contains stat data for a particular stat_header record, which it points
--   at via the stat_header_id field.

DROP TABLE IF EXISTS line_data_rhist;
CREATE TABLE line_data_rhist
(
    line_data_id   INT UNSIGNED NOT NULL,
    stat_header_id INT UNSIGNED NOT NULL,
    data_file_id   INT UNSIGNED NOT NULL,
    line_num       INT UNSIGNED,
    fcst_lead      INT,
    fcst_valid_beg DATETIME,
    fcst_valid_end DATETIME,
    fcst_init_beg  DATETIME,
    obs_lead       INT UNSIGNED,
    obs_valid_beg  DATETIME,
    obs_valid_end  DATETIME,
    total          INT UNSIGNED,

    n_rank         INT UNSIGNED,

    PRIMARY KEY (line_data_id),
    CONSTRAINT line_data_rhist_data_file_id_pk
        FOREIGN KEY (data_file_id)
            REFERENCES data_file (data_file_id),
    CONSTRAINT line_data_rhist_stat_header_id_pk
        FOREIGN KEY (stat_header_id)
            REFERENCES stat_header (stat_header_id),
    INDEX stat_header_id_idx (stat_header_id)
) ENGINE = MyISAM
  CHARACTER SET = latin1;

-- line_data_rhist_rank contains rank data for a particular line_data_rhist record.  The
--   number of ranks stored is given by the line_data_rhist field n_rank.

DROP TABLE IF EXISTS line_data_rhist_rank;
CREATE TABLE line_data_rhist_rank
(
    line_data_id INT UNSIGNED NOT NULL,
    i_value      INT UNSIGNED NOT NULL,
    rank_i       INT UNSIGNED,

    PRIMARY KEY (line_data_id, i_value)
) ENGINE = MyISAM
  CHARACTER SET = latin1;
