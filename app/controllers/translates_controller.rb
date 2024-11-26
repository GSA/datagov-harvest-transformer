# frozen_string_literal: true

require 'logger'

class TranslatesController < ApplicationController
  # POST /translates
  def create
    file_obj = params[:file]
    reader_name = params[:reader]
    writer_name = params[:writer]

    @md_return =
      ADIWG::Mdtranslator.translate(
        file: file_obj,
        reader: reader_name,
        writer: writer_name
      )

    logger = Logger.new($stdout)

    @md_return[:readerStructureMessages].each do |m|
      logger.warn(m) if m.include? 'WARNING'
      logger.info(m) if m.include? 'INFO'
      logger.error(m) if m.include? 'ERROR'
    end

    @md_return[:readerValidationMessages].each do |m|
      logger.warn(m) if m.include? 'WARNING'
      logger.info(m) if m.include? 'INFO'
      logger.error(m) if m.include? 'ERROR'
    end

    @response_info = {}
    @response_info[:success] = true
    @response_info[:readerStructureStatus] = 'OK'
    @response_info[:readerStructureMessages] = @md_return[
      :readerStructureMessages
    ]
    @response_info[:readerValidationStatus] = 'OK'
    @response_info[:readerValidationMessages] = @md_return[
      :readerValidationMessages
    ]
    @response_info[:readerExecutionStatus] = 'OK'
    @response_info[:readerExecutionMessages] = @md_return[
      :readerExecutionMessages
    ]
    @response_info[:writerStatus] = 'OK'
    @response_info[:writerMessages] = @md_return[:writerMessages]
    @response_info[:readerRequested] = @md_return[:readerRequested]
    @response_info[:readerVersionRequested] = @md_return[
      :readerVersionRequested
    ]
    @response_info[:readerVersionUsed] = @md_return[:readerVersionUsed]
    @response_info[:writerRequested] = @md_return[:writerRequested]
    @response_info[:writerVersion] = @md_return[:writerVersion]
    @response_info[:writerOutputFormat] = @md_return[:writerOutputFormat]
    @response_info[:writerForceValid] = @md_return[:writerForceValid]
    @response_info[:writerShowTags] = @md_return[:writerShowTags]
    @response_info[:writerCSSlink] = @md_return[:writerCSSlink]
    @response_info[:writerMissingIdCount] = @md_return[:writerMissingIdCount]
    @response_info[:translatorVersion] = @md_return[:translatorVersion]
    @response_info[:writerOutput] = @md_return[:writerOutput]

    # set messages Status (ERROR, WARNING, NOTICE, none)
    a_s_mess = @response_info[:readerStructureMessages]
    a_v_mess = @response_info[:readerValidationMessages]
    a_e_mess = @response_info[:readerExecutionMessages]
    a_w_mess = @response_info[:writerMessages]

    status = 'OK'
    status = 'NOTICE' if a_s_mess.any? { |s| s.include?('NOTICE') }
    status = 'WARNING' if a_s_mess.any? { |s| s.include?('WARNING') }
    status = 'ERROR' if a_s_mess.any? { |s| s.include?('ERROR') }
    @response_info[:readerStructureStatus] = status

    status = 'OK'
    status = 'NOTICE' if a_v_mess.any? { |s| s.include?('NOTICE') }
    status = 'WARNING' if a_v_mess.any? { |s| s.include?('WARNING') }
    status = 'ERROR' if a_v_mess.any? { |s| s.include?('ERROR') }
    @response_info[:readerValidationStatus] = status

    status = 'OK'
    status = 'NOTICE' if a_e_mess.any? { |s| s.include?('NOTICE') }
    status = 'WARNING' if a_e_mess.any? { |s| s.include?('WARNING') }
    status = 'ERROR' if a_e_mess.any? { |s| s.include?('ERROR') }
    @response_info[:readerExecutionStatus] = status

    status = 'OK'
    status = 'NOTICE' if a_w_mess.any? { |s| s.include?('NOTICE') }
    status = 'WARNING' if a_w_mess.any? { |s| s.include?('WARNING') }
    status = 'ERROR' if a_w_mess.any? { |s| s.include?('ERROR') }
    @response_info[:writerStatus] = status

    # check for errors returned by parser, validator, reader, and writer
    @response_info[:success] = false unless @md_return[:readerStructurePass]
    @response_info[:success] = false unless @md_return[:readerValidationPass]
    @response_info[:success] = false unless @md_return[:readerExecutionPass]
    @response_info[:success] = false unless @md_return[:writerPass]

    render json: @response_info, status: @response_info[:success] ? 200 : 422
  end
end
