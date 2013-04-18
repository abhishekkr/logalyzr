# Logalyzr

Logalyzr to analyze irregular logs.

## Usage

To get the entire help on how to use for what, run command below or read further

    $ logalyzr -h

    in verbose mode, add '-v'

##### better to have a days worth (or more shorter span) logs here for quicker analysis

it will create tracefiles and few other self-generated files in an $output_dir default value is ~/output_logalyzr
can be changed to desired path by providing new value at '-output-dir'

* automated full tracfile making, spanning errors from other logs
>  -err OR -errors OR --trace-span-errors
` $ logalyzr -errors $LOG_FILE `

* make TRACEFILES for all errors found in LOG_FILE
>  -trace OR --trace-errors
` $ logalyzr -trace $LOG_FILE `

* span the existing TRACEFILES with relevant logs from other logs in same directory OR provided log file
>  -span OR --span-errors  WITH -from --from-dir
` $ logalyzr -span $TRACEFILE -from $PATH_TO_OTHER_LOG_FILES_OR_LOG_FILE `

* lookup in existing TRACEFILES for InstanceID and grep matching InstanceID calls from provided log and place them in required output file
>  -tracebyid
` $ logalyzr -tracebyid $TRACEFILE -from $REQUIRED_LOG_FILE -to $DESIRED_OUTPUT_FILE `

* lookup for any pattern in a desired log-file and output it to required output file
` $ logalyzr -from $READ_FROM_LOG -to $WRITE_TO_LOG -grep $PATTERN `

* to keep it verbose
>  -v OR --verbose
` $ logalyzr -v -err $LOG_FILE_PATH `

.....more to come

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
