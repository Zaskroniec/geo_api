#!/bin/bash

# Run importer via gigalixir CLI in container
gigalixir_run distillery_eval "GeoImporter.Importer.process(\"cloud_data_dump.csv\")"