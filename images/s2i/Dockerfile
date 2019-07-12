FROM centos/ruby-25-centos7

USER root

ADD ./root /

RUN \
  set -x \
  yum install -y \
    # for minimagck gem
    ImageMagick \
  # Call restore-artifacts sscript when assembling
  sed '/Installing application source/i $STI_SCRIPTS_PATH/restore-artifacts' \
    -i $STI_SCRIPTS_PATH/assemble && \
  # Call post-assemble script when assembling
  echo -e "\n\$STI_SCRIPTS_PATH/post-assemble" >> $STI_SCRIPTS_PATH/assemble

USER 1001

ENV RAILS_ENV=production
