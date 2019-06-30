# template="template.conf"
# filename="test.conf"
# substitute=(var1 var2)

cp -f $template $filename

for item in ${substitute[*]}
do
    sed -i "s+{{${item}}}+${!item}+g" $filename
done
