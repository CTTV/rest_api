#!/usr/bin/env bash

# this is complicated because gnu date and BSD date have different implementations
STALEDATE=$(date --version &>/dev/null && date --date="3 days ago" +"%Y-%m-%d" || date -v-3d +"%Y"-"%m"-"%d")
echo ... will remove all STOPPED AppEngine versions older than $STALEDATE

gcloud --project=$GOOGLE_PROJECT_ID app versions list --format json --filter="version.createTime.date('%Y-%m-%d', Z)<$STALEDATE AND version.servingStatus=STOPPED" |\
     jq -r '.[] | .id' |\
     while read id
     do
        echo "Attempting to delete: $id in project $PROJECT"
        # TODO: to fix.. unless you send deletes as a background process,
        #  gcloud interrupts execution after the first succesful deletion (crazy!)
        gcloud --project=$GOOGLE_PROJECT_ID --quiet app versions delete $id
     done

done