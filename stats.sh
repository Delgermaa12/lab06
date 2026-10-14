#!/bin/bash
stat() {
  awk -F'\t' 'NR>1 {
    gsub(/~/, "")
    n++
    amt = ($3=="NonPositive"||$3=="OverBalance"||$3=="OverLimit")
    b = ($1!="Valid") + ($2!="Valid") + amt
    c[b]++
    if (($1!="Valid"||$2!="Valid") && amt) m++
  }
  END { printf "%d %d %d %d %d %d\n", n, c[0], c[1], c[2], c[3], m }' "$1"
}
read -r a1 a2 a3 a4 a5 a6 <<< "$(stat results/transfer-nc.txt)"
read -r b1 b2 b3 b4 b5 b6 <<< "$(stat results/transfer.txt)"
read -r c1 c2 c3 c4 c5 c6 <<< "$(stat results/transfer-neg.txt)"
echo "| Үзүүлэлт | transfer-nc | transfer | transfer-neg |"
echo "|---|---:|---:|---:|"
echo "| Нийт мөр | $a1 | $b1 | $c1 |"
echo "| 0 алдаатай мөр (happy path) | $a2 | $b2 | $c2 |"
echo "| 1 алдаатай мөр | $a3 | $b3 | $c3 |"
echo "| 2 алдаатай мөр | $a4 | $b4 | $c4 |"
echo "| 3 алдаатай мөр | $a5 | $b5 | $c5 |"
echo "| Дансны алдаа ба amount-ын алдаа давхцсан мөр | $a6 | $b6 | $c6 |"
