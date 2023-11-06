#!/bin/bash

function ffmpeg-screenshots() {
    infile="$( realpath ${1} )"
    nshot="${2:-10}"
    outdir="$( dirname ${infile} )"
    # get the color matrix | BT.709 / BT.601 / BT.2020
    color_matrix="$( mediainfo --Output="Video;%matrix_coefficients%" "${infile}" )"
    # duration in milliseconds
    duration_ms="$( mediainfo --Output="Video;%Duration%" "${infile}" )"
    # we don't first 10 minutes and last 10 minutes of video
    # fps is calculated equally spaced from the rest of the video
    # fps = nshot / total_duration
    fps=$( echo "${duration_ms}" "${nshot}" | awk '{ eff_dur = ($1/1000) - 1200; fps = $2/eff_dur; print fps }' )
    echo "Color Matrix: ${color_matrix}"
    color_matrix="${color_matrix:-BT.601}"
    outdir="${outdir}/${color_matrix}"
    mkdir -p "${outdir}"
    #f_colmat="bt709" # default
    #f_scale_anamorphic="'max(sar,1)*iw':'max(1/sar,1)*ih'"
    if [[ "${color_matrix}" == "BT.709" ]]; then
        f_colmat="bt709"
        f_scale_anamorphic="'max(sar,1)*iw':'max(1/sar,1)*ih'"
    elif [[ "${color_matrix}" == "BT.601" ]]; then
        f_colmat="bt601"
        f_scale_anamorphic="'max(sar,1)*iw':'max(1/sar,1)*ih'"
    elif [[ "${color_matrix}" == "BT.2020" ]]; then
        f_colmat="bt2020"
        f_scale_anamorphic=""
    fi
    echo "nshot= ${nshot}"
    echo "outdir= ${outdir}"
    echo "infile= ${infile}"
    echo "fps= ${fps}"
    echo "scale= ${f_scale_anamorphic}"
    echo "f_colmat= ${f_colmat}"
    echo "vf = \"fps=${fps}, scale=${f_scale_anamorphic}:in_h_chr_pos=0:in_v_chr_pos=128:in_color_matrix=${f_colmat}:flags=full_chroma_int+full_chroma_inp+accurate_rnd+spline\""
    ffmpeg \
        -ss 00:10:00.000 \
        -i "${infile}" \
        -vf "fps=${fps}, scale=${f_scale_anamorphic}:in_h_chr_pos=0:in_v_chr_pos=128:in_color_matrix=${f_colmat}:flags=full_chroma_int+full_chroma_inp+accurate_rnd+spline" \
        -pix_fmt rgb24 \
        -vframes "${nshot}" \
        "${outdir}/screenshot-%03d.png"
}
