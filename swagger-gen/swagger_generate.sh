#!/usr/bin/env bash

#Requires minumum JDK 7 or 8 on $PATH
#https://github.com/swagger-api/swagger-codegen/blob/master/README.md

#location of swagger codegen install
SWAGGER_CODEGEN=$HOME/swagger-codegen

#location of generated output
SWAGGER_CODEGEN_OUTPUT=cds_swagger_gen

#location of slate destination
CDS_SLATE_SWAGGER_DIR=../slate/source/includes/swagger

#Input Swagger file
INPUT_SWAGGER="$1"

echo "*** Checking if Swagger is valid: " $1
CHECK=$(curl -X "POST" "http://online.swagger.io/validator/debug" --silent -d @$1)
if [[ $CHECK != "{}" ]]; then
echo -e "\n*** Sorry this is an invalid Swagger:\n$CHECK\n"
exit 1
fi

# generate yamlS
echo "*** Generating swagger-yaml"
java -jar $SWAGGER_CODEGEN/swagger-codegen-cli.jar generate -i $INPUT_SWAGGER -l swagger-yaml -o $SWAGGER_CODEGEN_OUTPUT


FILENAME=`basename "${1}" .json`
OUTFILE="${FILENAME}.yaml"
# tell the user what is happening
echo "Changing Extension \"$FILENAME\" --> \"$OUTFILE\" ."

# move it to slate dir
echo "*** Moving to slate dir " $CDS_SLATE_SWAGGER_DIR
mv $SWAGGER_CODEGEN_OUTPUT/swagger.yaml $CDS_SLATE_SWAGGER_DIR/$OUTFILE
ls -la $CDS_SLATE_SWAGGER_DIR/$OUTFILE

# cleanup output
echo "*** Removing temporary swagger gen output dir" $SWAGGER_CODEGEN_OUTPUT
rm -Rf $SWAGGER_CODEGEN_OUTPUT

echo "*** Complete ***"
