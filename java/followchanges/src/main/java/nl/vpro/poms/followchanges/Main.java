package nl.vpro.poms.followchanges;

import lombok.extern.slf4j.Slf4j;
import nl.vpro.api.client.frontend.NpoApiClients;
import nl.vpro.api.client.utils.NpoApiMediaUtil;
import nl.vpro.domain.api.Deletes;
import nl.vpro.domain.api.MediaChange;
import nl.vpro.domain.api.Order;
import nl.vpro.domain.api.Tail;
import nl.vpro.util.CountedIterator;
import nl.vpro.util.Env;
import nl.vpro.util.TimeUtils;
import org.apache.commons.cli.*;

import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.time.Instant;
import java.util.Optional;

import static java.nio.charset.StandardCharsets.UTF_8;

/**
 * @author Michiel Meeuwissen
 */
@Slf4j
public class Main {



    public static void main(String[] argv) throws InterruptedException, ParseException {
        // output utf-8 always, why would you want it differently.
        System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out), true, UTF_8));

        Options options = new Options();
        Option env = new Option("e", "env", true, "environment");
        env.setRequired(false);;
        options.addOption(env);


        Option profile = new Option("p", "profile", true, "profile");
        profile.setRequired(false);
        options.addOption(profile);

        Option since = new Option("s", "since", true, "since");
        since.setRequired(false);
        options.addOption(since);

        CommandLineParser parser = new DefaultParser();
        CommandLine cmd = parser.parse(options, argv);

        Main main = new Main();
        main.changes(TimeUtils.parse(cmd.getOptionValue("since")).orElse(Instant.now()), cmd.getOptionValue("profile"), Env.valueOf(Optional.ofNullable(cmd.getOptionValue("env")).orElse("prod").toUpperCase()));
    }

    private void changes(Instant since, String profile, Env env) throws InterruptedException {
        NpoApiClients clients = NpoApiClients
            .configured(env)
            .build();

        NpoApiMediaUtil mediaUtil = NpoApiMediaUtil.builder()
            .clients(clients)
            .build();
        Instant start = since;
        String mid = null;
        int call = 0;
        while(true) {

            try (CountedIterator<MediaChange> changes = mediaUtil.changes(profile, false, start, mid, Order.ASC, null, Deletes.ID_ONLY, Tail.ALWAYS)) {
                while (changes.hasNext()) {
                    MediaChange change = changes.next();
                    log.info(call + ":" + change);
                    start = change.getPublishDate();
                    mid = change.getMid();
                }
            } catch (Exception e) {
                log.info(e.getMessage());
            }
            call++;
            Thread.sleep(1000L);
        }
    }
}
